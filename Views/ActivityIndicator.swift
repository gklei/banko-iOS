//
//  ActivityIndicator.swift
//  banko
//
//  Created by Gregory Klein on 10/2/20.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
   func makeUIView(context: Context) -> UIActivityIndicatorView {
      let indicator = UIActivityIndicatorView()
      indicator.startAnimating()
      return indicator
   }
   
   func updateUIView(_ uiView: UIActivityIndicatorView,
                     context: Context) {
   }
}
