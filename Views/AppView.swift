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
   
   init(user: User) {
      self.user = user
   }
   
   var loggedIn: Bool {
      return user.accessToken != nil
   }
}

struct AppView: View {
   @ObservedObject var viewModel: AppViewModel
   @ObservedObject var summaryViewModel: SummaryView.ViewModel
   @ObservedObject var profileViewModel: ProfileView.ViewModel
   @ObservedObject var loginViewModel: LoginView.ViewModel
   
   init(viewModel: AppViewModel) {
      self.viewModel = viewModel
      self.profileViewModel = ProfileView.ViewModel(user: viewModel.user)
      self.summaryViewModel = SummaryView.ViewModel(user: viewModel.user)
      self.loginViewModel = LoginView.ViewModel(user: viewModel.user)
   }
   
   var body: some View {
      if viewModel.loggedIn {
         TabView {
            NavigationView {
               SummaryView(viewModel: summaryViewModel)
                  .environmentObject(viewModel.user)
            }
            .tabItem {
               Image(systemName: "speedometer")
            }
            NavigationView {
               ExpensesView()
                  .environmentObject(viewModel.user)
            }
            .tabItem {
               Image(systemName: "dollarsign.circle")
            }
            NavigationView {
               ProfileView(viewModel: profileViewModel)
                  .environmentObject(viewModel.user)
               
            }
            .tabItem {
               Image(systemName: "person.fill")
            }
         }
         .onAppear(perform: {
            profileViewModel.loadInstitutions(forceReload: true)
            summaryViewModel.loadAccounts()
         })
      } else {
         NavigationView {
            LoginView(viewModel: loginViewModel)
         }
      }
   }
}
