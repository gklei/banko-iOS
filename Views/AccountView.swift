//
//  AccountView.swift
//  banko
//
//  Created by Gregory Klein on 10/2/20.
//

import SwiftUI

class AccountViewModel: ObservableObject {
   let account: LinkAccount
   
   init(account: LinkAccount) {
      self.account = account
   }
   
   var title: String {
      return account.name
   }
   
   var balance: String {
      let info = account.balanceInfo
      let bal = abs(info.available - (info.limit ?? 0))
      return String(format: "$%.2f", bal)
   }
}

struct AccountView: View {
   let viewModel: AccountViewModel
   
   init(viewModel: AccountViewModel) {
      self.viewModel = viewModel
   }
   
   var body: some View {
      Form {
         Section(header: Text("Balance")) {
            Text(viewModel.balance)
         }
      }
      .navigationTitle(viewModel.title)
   }
}
