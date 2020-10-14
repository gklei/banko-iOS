//
//  APIModels+Account.swift
//  banko
//
//  Created by Gregory Klein on 10/6/20.
//

import Foundation
import UIKit

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
}

struct LinkItemAccounts: Codable {
   enum CodingKeys: CodingKey {
      case accounts
      case item
   }
   
   let accounts: [LinkAccount]
   let item: LinkItem
}

struct LinkAccountsList: Codable {
   enum CodingKeys: String, CodingKey {
      case itemAccounts = "accounts"
   }
   
   let itemAccounts: [LinkItemAccounts]
}
