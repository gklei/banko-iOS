//
//  SignUpView.swift
//  banko_ios
//
//  Created by Gregory Klein on 9/29/20.
//

import SwiftUI
import Foundation

struct SignUpView: View {
   @Binding var showDetail: Bool
   
   var body: some View {
      NavigationView {
         Text("Sign up")
            .navigationBarTitle(Text("Sign Up"), displayMode: .inline)
            .navigationBarItems(
               leading: Button("Cancel") {self.showDetail = false}
            )
      }
   }
}
