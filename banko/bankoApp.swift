//
//  bankoApp.swift
//  banko
//
//  Created by Gregory Klein on 9/30/20.
//

import SwiftUI

@main
struct bankoApp: App {
   @ObservedObject var user = User(username: "greg", password: "ghk")
   var body: some Scene {
      WindowGroup {
         AppView(viewModel: AppViewModel(user: user))
            .accentColor(.purple)
      }
   }
}
