//
//  AppView.swift
//  banko
//
//  Created by Gregory Klein on 10/2/20.
//

import SwiftUI

struct AppView: View {
   @ObservedObject var user = CurrentUser(username: "greg", password: "ghk")
   var body: some View {
      if user.accessToken == nil {
         NavigationView {
            LoginView(viewModel: LoginViewModel(user: user))
         }
      } else {
         TabView {
            NavigationView {
               ProfileView().environmentObject(user)
            }
            .tabItem {
               Image(systemName: "chart.bar.fill")
            }
            NavigationView {
               SettingsView().environmentObject(user)
            }
            .tabItem {
               Image(systemName: "gear")
            }
         }
      }
   }
}

struct ProfileView: View {
   var body: some View {
      Text("hello")
         .navigationTitle("Profile")
   }
}
