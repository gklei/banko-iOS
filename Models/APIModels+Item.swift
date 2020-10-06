//
//  APIModels+Account.swift
//  banko
//
//  Created by Gregory Klein on 10/6/20.
//

import Foundation

struct LinkItem: Codable {
   enum CodingKeys: String, CodingKey {
      case availableProducts = "available_products"
      case billedProducts = "billed_products"
      case consentExpirationTime = "consent_expiration_time"
      case error
      case institutionID = "institution_id"
      case itemID = "item_id"
      case webhook
   }
   
   let availableProducts: [String]
   let billedProducts: [String]
   let consentExpirationTime: String?
   let error: String?
   let institutionID: String
   let itemID: String
   let webhook: String?
}

struct LinkItems: Codable {
   enum CodingKeys: CodingKey {
      case items
   }
   let items: [LinkItem]
}
