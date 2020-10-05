//
//  APIModels.swift
//  banko_ios
//
//  Created by Gregory Klein on 9/30/20.
//

import Foundation

class User: ObservableObject, Codable {
   @Published var username: String = ""
   @Published var password: String = ""
   @Published var accessToken: String? = nil
   
   enum CodingKeys: String, CodingKey {
      case username
      case password
      case accessToken = "access_token"
   }
   
   required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      username = try container.decode(String.self, forKey: .username)
      password = try container.decode(String.self, forKey: .password)
      accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(username, forKey: .username)
      try container.encode(password, forKey: .password)
      try container.encodeIfPresent(accessToken, forKey: .accessToken)
   }
   
   init(username: String, password: String) {
      self.username = username
      self.password = password
   }
}

class AuthResponse: Codable {
   enum CodingKeys: String, CodingKey {
      case value = "access_token"
   }
   
   @Published var value = ""
   
   required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      value = try container.decode(String.self, forKey: .value)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(value, forKey: .value)
   }
}

class MessageResponse: Codable {
   enum CodingKeys: CodingKey {
      case message
   }
   
   var message: String = ""
   
   required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      message = try container.decode(String.self, forKey: .message)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(message, forKey: .message)
   }
}
