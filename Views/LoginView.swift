//
//  ContentView.swift
//  banko_ios
//
//  Created by Gregory Klein on 9/28/20.
//

import SwiftUI
import Combine

struct LoginView: View {
   class ViewModel: ObservableObject {
      @ObservedObject var user: User
      private var disposables = Set<AnyCancellable>()
      
      init(user: User) {
         self.user = user
      }
   }
   
   @State var showingSignup = false
   @ObservedObject var viewModel: LoginView.ViewModel
   
   init(viewModel: LoginView.ViewModel) {
      self.viewModel = viewModel
   }
   
   var body: some View {
      VStack {
         Form {
            Section(header: Text("Log Into your Account")) {
               TextField("Username", text: $viewModel.user.username).autocapitalization(.none)
               SecureField("Password", text: $viewModel.user.password)
            }
            Section {
               Button("Login", action: viewModel.authenticate)
            }
            .disabled(!viewModel.canTryLogin)
         }
         .navigationBarItems(
            trailing: Button("Sign Up") {
               showingSignup.toggle()
            }
         )
         .navigationTitle("Banko")
      }
      .sheet(isPresented: $showingSignup) {
         SignUpView(showDetail: $showingSignup)
            .accentColor(.purple)
      }
   }
}

extension LoginView.ViewModel {
   var canTryLogin: Bool {
      return user.username.count > 0 && user.password.count > 0
   }
   
   func authenticate() {
      BankoAPI.auth(user: user)
         .map({ ($0 as AuthResponse).value })
         .sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] in
               guard let self = self else { return }
               self.user.accessToken = $0
            }
         )
         .store(in: &disposables)
   }
}
