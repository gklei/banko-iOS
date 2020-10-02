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

struct NewView: View {
   var body: some View {
      Text("Hello")
   }
}

struct SettingsView: View {
   @EnvironmentObject var user: CurrentUser
   @StateObject var linkTokenViewModel = LinkTokenViewModel()
   
   @State var getLinkTokenCancellable: AnyCancellable? = nil
   @State var createItemCancellable: AnyCancellable? = nil
   @State var getAccountsCancellable: AnyCancellable? = nil
   
   @State var accounts: [LinkAccount] = []
   
   @State private var showLink = false
   
   var body: some View {
      Form {
         Section(header: Text("Username")) {
            Text(user.username)
         }
         if self.accounts.count == 0 {
            ActivityIndicator()
         }
         if self.accounts.count > 0 {
            Section(header: Text("Linked Accounts")) {
               List(self.accounts) { account in
                  NavigationLink(destination: NewView()) {
                     Text(account.name)
                     Spacer()
                     Text(account.mask ?? "").font(.system(.subheadline))
                  }
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
      .navigationTitle("Settings")
      .sheet(
         isPresented: self.$showLink,
         onDismiss: {
            self.showLink = false
            self.createLinkItem()
         }, content: {
            LinkView(viewModel: self.linkTokenViewModel)
         }
      )
      .onAppear(perform: loadAccounts)
   }
   
   func loadAccounts() {
      guard accounts.count == 0 else { return }
      let items = BankoAPI.getLinkItems(user: user)
      let firstItem = items.compactMap { $0.items.first }
      let accounts = firstItem.flatMap { item in
         BankoAPI.getAccounts(user: self.user, item: item)
      }
      
      getAccountsCancellable = accounts
         .map({$0.accounts})
         .replaceError(with: [])
         .assign(to: \SettingsView.accounts, on: self)
   }
   
   func getAccessToken() {
      getLinkTokenCancellable = BankoAPI
         .createLinkToken(user: user)
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
         .createLinkItem(user: user, publicToken: publicToken)
         .sink(
            receiveCompletion: { _ in },
            receiveValue: {
               print("Created Link Item with ID: \($0.itemID)")
            }
         )
   }
}
