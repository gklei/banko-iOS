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

struct ProfileView: View {
   class ViewModel: ObservableObject {
      @Published var user: User
      @Published var state: LoadableState<[LinkInstitution]> = .notLoaded
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
   @StateObject var linkTokenViewModel = LinkTokenViewModel()
   @State var getLinkTokenCancellable: AnyCancellable? = nil
   @State var createItemCancellable: AnyCancellable? = nil
   @State private var showLink = false
   
   @ObservedObject var viewModel: ViewModel
   
   init(viewModel: ViewModel) {
      self.viewModel = viewModel
   }
   
   var body: some View {
      Form {
         viewModel.usernameSection
         viewModel.linkedInstitutionsSection
      }
      .navigationBarItems(
         leading: Button("Log Out") { viewModel.logOut() },
         trailing: Button("Add Account") { getAccessToken() }
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
            receiveValue: { item in
               self.viewModel.loadInstitutions(forceReload: true)
            }
         )
   }
}

extension ProfileView.ViewModel {
   @ViewBuilder var usernameSection: some View {
      Section(header: Text("Username")) {
         Text(user.username)
      }
   }
   
   func loadInstitutions(forceReload: Bool = false) {
      if forceReload {
         state = .notLoaded
      }
      switch state {
      case .loaded(_): return
      default: break
      }
      state = .loading
      BankoAPI.getLinkedInstitutions(user: user)
         .map({ $0.institutions })
         .sink(
            receiveCompletion: { result in
               print(result)
               switch result {
               case .failure(let error): self.state = .error(error)
               case .finished: break
               }
            },
            receiveValue: { self.state = .loaded($0) })
         .store(in: &disposables)
   }
   
   func logOut() {
      user.accessToken = nil
      user.username = ""
      user.password = ""
   }
   
   @ViewBuilder func institutionsList(_ institutions: [LinkInstitution]) -> some View {
      List(institutions) { institution in
         NavigationLink(
            destination: InstitutionView(
               viewModel: InstitutionView.ViewModel(institution: institution)
            )
         ) {
            HStack {
               Text(institution.name).font(.subheadline)
               Spacer()
               Image(uiImage: institution.logo ?? UIImage())
                  .resizable()
                  .frame(width: 20.0, height: 20.0)
            }
         }
      }
   }
   
   @ViewBuilder var linkedInstitutionsSection: some View {
      Section(header: Text("Linked Institutions")) {
         switch state {
         case .notLoaded: EmptyView()
         case .loading: ActivityIndicator()
         case .loaded(let institutions):
            if institutions.count > 0 {
               institutionsList(institutions)
            } else {
               Text("No accounts have been linked").font(.subheadline)
            }
         case .error(_): Text("Something went wrong")
         }
      }
   }
}
