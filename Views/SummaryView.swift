//
//  SummaryView.swift
//  banko
//
//  Created by Gregory Klein on 10/2/20.
//

import SwiftUI
import Combine

struct SummaryView: View {
   class ViewModel: ObservableObject {
      @Published var user: User
      @Published var state: LoadableState<[LinkItemAccounts]> = .notLoaded
      private var disposables = Set<AnyCancellable>()
      
      
      init(user: User) {
         self.user = user
      }
   }
   @EnvironmentObject var user: User {
      didSet {
         if user.accessToken == nil {
            viewModel.state = .notLoaded
         }
      }
   }
   @ObservedObject var viewModel: ViewModel
   
   init(viewModel: ViewModel) {
      self.viewModel = viewModel
   }
   
   var body: some View {
      Form {
         viewModel.balanceSection
         viewModel.breakdownSection
      }
      .navigationTitle("Summary")
   }
}

extension SummaryView.ViewModel {
   func loadAccounts() {
      switch state {
      case .error(_): self.fetchAccounts()
      case .notLoaded: self.fetchAccounts()
      case .loading: return
      case .loaded(_): return
      }
   }
   
   func fetchAccounts() {
      state = .loading
      BankoAPI.getAccounts(user: user)
         .map({ $0.itemAccounts })
         .sink(
            receiveCompletion: {result in
               switch result {
               case .failure(let error): self.state = .error(error)
               case .finished: break
               }
            },
            receiveValue: { self.state = .loaded($0)
         })
         .store(in: &disposables)
   }
   
   func groupBalance(_ group: LinkItemAccounts, type: LinkAccount.AccountType) -> String {
      return String(format: "$%.2f", group.absBalance(type))
   }
   
   func accountBalance(_ account: LinkAccount) -> String {
      return String(format: "$%.2f", account.balanceInfo.current)
   }
   
   @ViewBuilder var balanceSection: some View {
      Section(header: Text("Total Balances")) {
         switch state {
         case .loading: ActivityIndicator()
         case .loaded(let groups):
            HStack {
               Text("Cash")
               Spacer()
               if let group = groups.first {
                  Text(groupBalance(group, type: .depository))
                     .font(.subheadline)
                     .foregroundColor(.green)
                     .fontWeight(.bold)
               } else {
                  Text("—").foregroundColor(.green)
               }
            }
            HStack {
               Text("Debt")
               Spacer()
               if let group = groups.first {
                  Text(groupBalance(group, type: .credit))
                     .font(.subheadline)
                     .foregroundColor(.red)
                     .fontWeight(.bold)
               } else {
                  Text("—").foregroundColor(.red)
               }
            }
         case .notLoaded: EmptyView()
         case .error(_): Text("Something went wrong").font(.subheadline)
         }
      }
   }
   
   @ViewBuilder var breakdownSection: some View {
      Section(header: Text("Debt Breakdown")) {
         switch state {
         case .loading: ActivityIndicator()
         case .loaded(let accounts):
            if let accountGroup = accounts.first {
               let accounts = accountGroup.filterAccounts(.credit)
               if accounts.count > 0 {
                  List(accounts) { account in
                     Text(account.name).font(.subheadline)
                     Spacer()
                     Text(self.accountBalance(account)).font(.subheadline)
                  }
               } else {
                  Text("No credit accounts found").font(.subheadline)
               }
            } else {
               Text("No accounts have been linked").font(.subheadline)
            }
         case .notLoaded: EmptyView()
         case .error(_): Text("Something went wrong").font(.subheadline)
         }
      }
   }
}

extension LinkItemAccounts {
   func filterAccounts(_ type: LinkAccount.AccountType) -> [LinkAccount] {
      return accounts.filter { $0.type == type }
   }
   
   func absBalance(_ type: LinkAccount.AccountType) -> Float {
      return filterAccounts(type).reduce(0, { $0 + $1.balanceInfo.current })
   }
}
