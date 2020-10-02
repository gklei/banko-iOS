//
//  ProfileView.swift
//  banko_ios
//
//  Created by Gregory Klein on 9/30/20.
//

import SwiftUI
import Combine
import LinkKit

class LinkTokenViewModel: ObservableObject {
   @Published var linkToken: String? = nil
   @Published var publicToken: String? = nil
}

struct SettingsView: View {
   @EnvironmentObject var currentUser: CurrentUser
   @StateObject var linkTokenViewModel = LinkTokenViewModel()
   
   @State var getLinkTokenCancellable: AnyCancellable? = nil
   @State var createItemCancellable: AnyCancellable? = nil
   @State var getItemsCancellable: AnyCancellable? = nil
   @State var getAccountsCancellable: AnyCancellable? = nil
   
   @State var accounts: [LinkAccount] = []
   @State private var showLink = false
   
   var body: some View {
      Form {
         Section(header: Text("Username:")) {
            Text(currentUser.username)
         }
         if self.accounts.count > 0 {
            Section(header: Text("Linked Accounts")) {
               ForEach(self.accounts, id: \.accountID) { account in
                  Text(account.name)
               }
            }
         }
      }
      .navigationBarItems(
         trailing: Button("Add Account") {
            self.getLinkTokenCancellable?.cancel()
            self.getAccessToken()
         }
      )
      .navigationTitle("Profile")
      .navigationBarBackButtonHidden(true)
      .sheet(
         isPresented: self.$showLink,
         onDismiss: {
            self.showLink = false
            self.createLinkItem()
         }, content: {
            LinkView(viewModel: self.linkTokenViewModel)
         }
      )
      .onAppear(perform: getItems)
   }
   
   func getItems() {
      getItemsCancellable = BankoAPI
         .getLinkItems(user: currentUser)
         .sink(
            receiveCompletion: { _ in },
            receiveValue: {
               print($0)
               for item in $0.items {
                  self.getAccounts(item: item)
               }
            }
         )
   }
   
   func getAccounts(item: LinkItem) {
      getAccountsCancellable = BankoAPI
         .getAccounts(user: currentUser, item: item)
         .map({$0.accounts})
         .sink(
            receiveCompletion: { _ in },
            receiveValue: {
               self.accounts = $0
            }
         )
   }
   
   func getAccessToken() {
      getLinkTokenCancellable = BankoAPI
         .createLinkToken(user: currentUser)
         .map({ $0.value })
         .sink(
            receiveCompletion: { _ in },
            receiveValue: {
               self.linkTokenViewModel.linkToken = $0
               self.showLink = true
            }
         )
   }
   
   func createLinkItem() {
      guard let token = linkTokenViewModel.publicToken else { return }
      let publicToken = LinkPublicToken(tokenValue: token)
      
      createItemCancellable = BankoAPI
         .createLinkItem(user: currentUser, publicToken: publicToken)
         .map({ $0.itemID })
         .sink(
            receiveCompletion: { _ in },
            receiveValue: {
               print("Created Link Item with ID: \($0)")
            }
         )
   }
}

struct ProfileView_Previews: PreviewProvider {
   static var previews: some View {
      SettingsView()
   }
}
