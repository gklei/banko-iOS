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
   let webook: String?
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      availableProducts = try container.decode([String].self, forKey: .availableProducts)
      billedProducts = try container.decode([String].self, forKey: .billedProducts)
      consentExpirationTime = try container.decodeIfPresent(String.self, forKey: .consentExpirationTime)
      error = try container.decodeIfPresent(String.self, forKey: .error)
      institutionID = try container.decode(String.self, forKey: .institutionID)
      itemID = try container.decode(String.self, forKey: .itemID)
      webook = try container.decodeIfPresent(String.self, forKey: .webhook)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(availableProducts, forKey: .availableProducts)
      try container.encode(billedProducts, forKey: .billedProducts)
      try container.encode(consentExpirationTime, forKey: .consentExpirationTime)
      try container.encode(error, forKey: .error)
      try container.encode(institutionID, forKey: .institutionID)
      try container.encode(itemID, forKey: .itemID)
      try container.encode(webook, forKey: .webhook)
   }
}

struct LinkItems: Codable {
   enum CodingKeys: CodingKey {
      case items
   }
   let items: [LinkItem]
}

struct LinkAccount: Codable, Identifiable {
   struct BalanceInfo: Codable {
      enum CodingKeys: String, CodingKey {
         case available
         case current
         case isoCurrencyCode = "iso_currency_code"
         case limit
         case unofficialCurrencyCode = "unofficial_currency_code"
      }
      
      let available: Float
      let current: Float
      let isoCurrencyCode: String
      let limit: Float?
      let unofficialCurrencyCode: String?
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         available = try container.decode(Float.self, forKey: .available)
         current = try container.decode(Float.self, forKey: .current)
         isoCurrencyCode = try container.decode(String.self, forKey: .isoCurrencyCode)
         limit = try container.decodeIfPresent(Float.self, forKey: .limit)
         unofficialCurrencyCode = try container.decodeIfPresent(String.self, forKey: .unofficialCurrencyCode)
      }
      
      func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(available, forKey: .available)
         try container.encode(current, forKey: .current)
         try container.encode(isoCurrencyCode, forKey: .isoCurrencyCode)
         try container.encodeIfPresent(limit, forKey: .limit)
         try container.encodeIfPresent(unofficialCurrencyCode, forKey: .unofficialCurrencyCode)
      }
   }
   
   enum AccountType: String, Codable {
      enum CodingKeys: CodingKey {
         case credit
         case depository
         case loan
         case other
      }
      
      case credit
      case depository
      case loan
      case other
   }
   
   enum CodingKeys: String, CodingKey {
      case accountID = "account_id"
      case balanceInfo = "balances"
      case mask
      case name
      case officialName = "official_name"
      case subtype
      case type
   }

   let id = UUID()
   let accountID: String
   let balanceInfo: BalanceInfo
   let mask: String?
   let name: String
   let officialName: String?
   let subtype: String
   let type: AccountType
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      accountID = try container.decode(String.self, forKey: .accountID)
      balanceInfo = try container.decode(BalanceInfo.self, forKey: .balanceInfo)
      mask = try container.decodeIfPresent(String.self, forKey: .mask)
      name = try container.decode(String.self, forKey: .name)
      officialName = try container.decodeIfPresent(String.self, forKey: .officialName)
      subtype = try container.decode(String.self, forKey: .subtype)
      type = try container.decode(AccountType.self, forKey: .type)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(accountID, forKey: .accountID)
      try container.encodeIfPresent(mask, forKey: .mask)
      try container.encode(name, forKey: .name)
      try container.encodeIfPresent(officialName, forKey: .officialName)
      try container.encode(subtype, forKey: .subtype)
      try container.encode(type, forKey: .type)
   }
}

struct LinkAccountGroup: Codable {
   enum CodingKeys: CodingKey {
      case accounts
      case item
   }
   
   let accounts: [LinkAccount]
   let item: LinkItem
}

struct LinkAccountsList: Codable {
   enum CodingKeys: CodingKey {
      case accounts
   }
   
   let accounts: [LinkAccountGroup]
}

struct Institution: Codable, Identifiable {
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
//      try container.encode(logo, forKey: .logo)
      try container.encode(name, forKey: .name)
      try container.encode(primaryColor, forKey: .primaryColor)
   }
}

struct LinkedInstitutions: Codable {
   enum CodingKeys: CodingKey {
      case institutions
   }
   
   let institutions: [Institution]
}
