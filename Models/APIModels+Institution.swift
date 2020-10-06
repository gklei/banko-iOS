//
//  APIModels+Institution.swift
//  banko
//
//  Created by Gregory Klein on 10/6/20.
//

import Foundation
import UIKit

struct LinkInstitution: Codable, Identifiable {
   enum CodingKeys: String, CodingKey {
      case itemID = "item_id"
      case institutionID = "institution_id"
      case logo
      case name
      case primaryColor = "primary_color"
   }
   
   let id = UUID()
   let institutionID: String
   let itemID: String
   let logo: UIImage?
   let name: String
   let primaryColor: String
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      itemID = try container.decode(String.self, forKey: .itemID)
      institutionID = try container.decode(String.self, forKey: .institutionID)
      
      let data = try container.decode(String.self, forKey: .logo)
      if let imageData = Data.init(base64Encoded: data, options: .init(rawValue: 0)) {
         logo = UIImage(data: imageData)
      } else {
         logo = nil
      }
      
      name = try container.decode(String.self, forKey: .name)
      primaryColor = try container.decode(String.self, forKey: .primaryColor)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(itemID, forKey: .itemID)
      try container.encode(institutionID, forKey: .institutionID)
      
      let data = logo?.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
      try container.encode(data, forKey: .logo)

      try container.encode(name, forKey: .name)
      try container.encode(primaryColor, forKey: .primaryColor)
   }
}

struct LinkedInstitutions: Codable {
   enum CodingKeys: CodingKey {
      case institutions
   }
   
   let institutions: [LinkInstitution]
}
