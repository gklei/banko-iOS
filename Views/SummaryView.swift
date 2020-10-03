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

class SummaryViewModel: ObservableObject {
   @Published var user: User
   
   init(user: User) {
      self.user = user
   }
   
   func totalBalance(for accountType: LinkAccount.AccountType) -> String? {
      guard let accounts = user.accounts?.accounts(for: accountType) else { return nil }
      let total: Float = accounts.map({$0.balanceInfo}).reduce(0, { $0 + (($1.limit ?? 0) - $1.available) })
      return String(format: "$%.2f", abs(total))
   }
   
   @ViewBuilder var balanceSection: some View {
      Section(header: Text("Total Balances")) {
         HStack {
            Text("Cash")
            Spacer()
            if let text = totalBalance(for: .depository) {
               Text(text)
                  .font(.system(.subheadline))
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
                  .font(.system(.subheadline))
                  .foregroundColor(Color.red)
            } else {
               ActivityIndicator()
            }
         }
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
      }
      .navigationTitle("Summary")
   }
}
