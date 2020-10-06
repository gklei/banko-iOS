//
//  APIModels+Link.swift
//  banko
//
//  Created by Gregory Klein on 10/1/20.
//

import Foundation
import UIKit

struct LinkAccessToken: Codable {
   enum CodingKeys: String, CodingKey {
      case linkToken = "link_token"
   }
   
   let value: String
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      value = try container.decode(String.self, forKey: .linkToken)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(value, forKey: .linkToken)
   }
}

struct LinkPublicToken: Codable {
   enum CodingKeys: String, CodingKey {
      case publicToken = "public_token"
   }
   
   let value: String
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      value = try container.decode(String.self, forKey: .publicToken)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(value, forKey: .publicToken)
   }
   
   init(tokenValue: String) {
      self.value = tokenValue
   }
}

struct CreateLinkItemResponse: Codable {
   enum CodingKeys: String, CodingKey {
      case itemID = "item_id"
   }
   
   let itemID: String
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      itemID = try container.decode(String.self, forKey: .itemID)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(itemID, forKey: .itemID)
   }
}
