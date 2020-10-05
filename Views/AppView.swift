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
   
   init(viewModel: AppViewModel) {
      self.viewModel = viewModel
   }
   
   var body: some View {
      if viewModel.loggedIn {
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
      } else {
         NavigationView {
            LoginView(
               viewModel: LoginViewModel(
                  user: viewModel.user
               )
            )
         }
      }
   }
}
