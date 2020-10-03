//
//  AppView.swift
//  banko
//
//  Created by Gregory Klein on 10/2/20.
//

import SwiftUI
import Combine

class AppViewModel: ObservableObject {
   @Published var user: User
   private var disposables = Set<AnyCancellable>()
   
   init(user: User) {
      self.user = user
   }
   
   var loggedIn: Bool {
      return user.accessToken != nil
   }
   
   func fetchAccounts() {
      BankoAPI.getLinkItems(user: user)
         .compactMap { $0.items.first }
         .flatMap { BankoAPI.getAccounts(user: self.user, item: $0) }
         .sink(
            receiveCompletion: { _ in },
            receiveValue: { self.user.accounts = $0 })
         .store(in: &disposables)
   }
}

struct AppView: View {
   @ObservedObject var viewModel: AppViewModel
   
   init(viewModel: AppViewModel) {
      self.viewModel = viewModel
   }
   
   var body: some View {
      if !viewModel.loggedIn {
         NavigationView {
            LoginView(viewModel: LoginViewModel(user: viewModel.user))
         }
      } else {
         TabView {
            NavigationView {
               SummaryView(
                  viewModel: SummaryViewModel(
                     user: viewModel.user
                  )
               ).environmentObject(viewModel.user)
            }
            .tabItem {
               Image(systemName: "speedometer")
            }
            NavigationView {
               ExpensesView().environmentObject(viewModel.user)
            }
            .tabItem {
               Image(systemName: "dollarsign.circle")
            }
            NavigationView {
               ProfileView(
                  viewModel: ProfileViewModel(
                     user: viewModel.user
                  )
               ).environmentObject(viewModel.user)
            }
            .tabItem {
               Image(systemName: "person.fill")
            }
         }
         .onAppear(perform: viewModel.fetchAccounts)
      }
   }
}
