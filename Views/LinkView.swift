//
//  LinkView.swift
//  banko
//
//  Created by Gregory Klein on 9/30/20.
//

import SwiftUI
import LinkKit

struct LinkView: View {
   var viewModel: LinkTokenViewModel
   
   var body: some View {
      LinkController(viewModel: viewModel)
   }
}

struct LinkController: UIViewControllerRepresentable {
   var viewModel: LinkTokenViewModel
   
   func makeCoordinator() -> LinkController.Coordinator {
      return Coordinator(self)
   }
   
   func makeUIViewController(context: Context) -> PLKPlaidLinkViewController {
      guard let token = viewModel.linkToken else { fatalError() }
      let config = PLKConfiguration(linkToken: token)
      return PLKPlaidLinkViewController(linkToken: token, configuration: config, delegate: context.coordinator)
   }
   
   func updateUIViewController(_ uiViewController: PLKPlaidLinkViewController, context: Context) {
   }
   
   class Coordinator: NSObject, PLKPlaidLinkViewDelegate {
      var parent: LinkController
      
      init(_ parent: LinkController) {
         self.parent = parent
      }
      
      // MARK: PLKPlaidLinkViewDelegate
      func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
         linkViewController.dismiss(animated: true, completion: nil)
         print("success!")
         parent.viewModel.publicToken = publicToken
      }
      
      func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
         linkViewController.dismiss(animated: true, completion: nil)
         print("exit!")
         parent.viewModel.publicToken = nil
      }
   }
}
