//
//  SummaryView.swift
//  banko
//
//  Created by Gregory Klein on 10/2/20.
//

import SwiftUI

extension LinkAccounts {
   func accounts(for type: LinkAccount.AccountType) -> [LinkAccount] {
      return self.accounts.filter { $0.type == type }
   }
}

extension LinkAccount {
   var absBalance: Float {
      return abs((balanceInfo.limit ?? 0) - balanceInfo.available)
   }
}

class SummaryViewModel: ObservableObject {
   @Published var user: User
   
   init(user: User) {
      self.user = user
   }
   
   func totalBalance(for accountType: LinkAccount.AccountType) -> String? {
      guard let accounts = user.accounts?.accounts(for: accountType) else { return nil }
      let total: Float = accounts.reduce(0, { $0 + $1.absBalance })
      return String(format: "$%.2f", total)
   }
   
   func balance(for account: LinkAccount) -> String {
      return String(format: "$%.2f", account.absBalance)
   }
   
   @ViewBuilder var balanceSection: some View {
      Section(header: Text("Total Balances")) {
         HStack {
            Text("Cash")
            Spacer()
            if let text = totalBalance(for: .depository) {
               Text(text)
                  .font(.subheadline)
                  .foregroundColor(Color.green)
            } else {
               ActivityIndicator()
            }
         }
         HStack {
            Text("Debt")
            Spacer()
            if let text = totalBalance(for: .credit) {
               Text(text)
                  .font(.subheadline)
                  .foregroundColor(Color.red)
            } else {
               ActivityIndicator()
            }
         }
      }
   }
   
   @ViewBuilder var breakdownSection: some View {
      if let accounts = user.accounts?.accounts(for: .credit) {
         if accounts.count > 0 {
            Section(header: Text("Debt Breakdown")) {
               List(accounts) { account in
                  Text(account.name)
                  Spacer()
                  Text(self.balance(for: account)).font(.subheadline)
               }
            }
         } else {
            Text("No accounts have been linked")
         }
      } else {
         ActivityIndicator()
      }
   }
}

struct SummaryView: View {
   @EnvironmentObject var user: User
   var viewModel: SummaryViewModel
   
   init(viewModel: SummaryViewModel) {
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
