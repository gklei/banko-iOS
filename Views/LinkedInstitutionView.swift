//
//  LinkedInstitutionView.swift
//  banko
//
//  Created by Gregory Klein on 10/6/20.
//

import SwiftUI

struct InstitutionView: View {
   class ViewModel: ObservableObject {
      let institution: Institution
      
      init(institution: Institution) {
         self.institution = institution
      }
   }
   
   @ObservedObject var viewModel: ViewModel
   
    var body: some View {
      Form {
         viewModel.infoSection
      }
      .navigationTitle("Linked Account")
    }
}

extension InstitutionView.ViewModel {
   var title: String {
      return institution.name
   }
   
   @ViewBuilder var infoSection: some View {
      Section(header: Text("Name")) {
         HStack {
            Text(institution.name).font(.subheadline)
            Spacer()
            Image(uiImage: institution.logo ?? UIImage())
               .resizable()
               .frame(width: 20.0, height: 20.0)
         }
      }
      Section(header: Text("Institution ID")) {
         Text(institution.institutionID).font(.subheadline)
      }
      Section(header: Text("Item ID")) {
         Text(institution.itemID).font(.subheadline)
      }
   }
}
