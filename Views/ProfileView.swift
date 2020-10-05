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
   private var disposables = Set<AnyCancellable>()
}

class ProfileViewModel: ObservableObject {
   @Published var user: User
   
   init(user: User) {
      self.user = user
   }
   
   @ViewBuilder var usernameSection: some View {
      Section(header: Text("Username")) {
         Text(user.username)
      }
   }
}

struct ProfileView: View {
   @EnvironmentObject var user: User
   @StateObject var linkTokenViewModel = LinkTokenViewModel()
   
   @ObservedObject var viewModel: ProfileViewModel
   @State var getLinkTokenCancellable: AnyCancellable? = nil
   @State var createItemCancellable: AnyCancellable? = nil
   @State private var showLink = false
   
   init(viewModel: ProfileViewModel) {
      self.viewModel = viewModel
   }
   
   var body: some View {
      Form {
         viewModel.usernameSection
      }
      .navigationBarItems(
         leading: Button("Log Out") {
            user.accessToken = nil
         },
         trailing: Button("Add Account") {
            getLinkTokenCancellable?.cancel()
            getAccessToken()
         }i
      )
      .navigationTitle("Profile")
      .sheet(
         isPresented: self.$showLink,
         onDismiss: {
            self.showLink = false
            self.createLinkItem()
         }, content: {
            LinkView(viewModel: self.linkTokenViewModel)
         }
      )
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
