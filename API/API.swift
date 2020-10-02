//
//  API.swift
//  banko_ios
//
//  Created by Gregory Klein on 9/28/20.
//

import Combine
import Foundation
import LinkKit

enum RequestError: Error {
   case sessionError(error: Error)
}

struct Agent {
   struct Response<T> {
      let value: T
      let response: URLResponse
   }
   
   func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
      return URLSession.shared
         .dataTaskPublisher(for: request)
         .tryMap { result -> Response<T> in
            let value = try JSONDecoder().decode(T.self, from: result.data)
            return Response(value: value, response: result.response)
         }
         .receive(on: DispatchQueue.main)
         .eraseToAnyPublisher()
   }
}

enum BankoAPI {
   static let agent = Agent()
   static let base = URL(string: "http://127.0.0.1:5000/")!
   
   static func headers(for user: CurrentUser) -> [String: String] {
      guard let token = user.accessToken else { return [:] }
      return [
         "Content-Type": "application/json",
         "Authorization": "JWT \(token)"
      ]
   }
}

extension BankoAPI {
   static func auth(user: CurrentUser) -> AnyPublisher<AuthResponse, Error> {
      let encoder = JSONEncoder()
      guard let postData = try? encoder.encode(user) else { fatalError() }
      
      let headers = [
         "Content-Type": "application/json",
      ]
      var request = URLRequest(
         url: base.appendingPathComponent("auth"),
         cachePolicy: .useProtocolCachePolicy,
         timeoutInterval: 10.0
      )
      request.httpMethod = "POST"
      request.allHTTPHeaderFields = headers
      request.httpBody = postData as Data
      return agent.run(request)
         .map(\.value)
         .eraseToAnyPublisher()
   }
   
   static func createLinkToken(user: CurrentUser) -> AnyPublisher<LinkAccessToken, Error> {
      var request = URLRequest(
         url: base.appendingPathComponent("create_link_token"),
         cachePolicy: .useProtocolCachePolicy,
         timeoutInterval: 10.0
      )
      request.httpMethod = "GET"
      request.allHTTPHeaderFields = headers(for: user)
      return agent.run(request)
         .map(\.value)
         .eraseToAnyPublisher()
   }
   
   static func createLinkItem(user: CurrentUser, publicToken: LinkPublicToken) -> AnyPublisher<CreateLinkItemResponse, Error> {
      let encoder = JSONEncoder()
      guard let postData = try? encoder.encode(publicToken) else { fatalError() }
      var request = URLRequest(
         url: base.appendingPathComponent("create_link_item"),
         cachePolicy: .useProtocolCachePolicy,
         timeoutInterval: 10.0
      )
      request.httpMethod = "POST"
      request.allHTTPHeaderFields = headers(for: user)
      request.httpBody = postData as Data
      return agent.run(request)
         .map(\.value)
         .eraseToAnyPublisher()
   }
   
   static func getLinkItems(user: CurrentUser) -> AnyPublisher<LinkItems, Error> {
      var request = URLRequest(
         url: base.appendingPathComponent("link_items"),
         cachePolicy: .useProtocolCachePolicy,
         timeoutInterval: 10.0
      )
      request.httpMethod = "GET"
      request.allHTTPHeaderFields = headers(for: user)
      return agent.run(request)
         .map(\.value)
         .eraseToAnyPublisher()
   }
   
   static func getAccounts(user: CurrentUser, item: LinkItem) -> AnyPublisher<LinkAccounts, Error> {
      var request = URLRequest(
         url: base.appendingPathComponent("link_item/\(item.itemID)/accounts"),
         cachePolicy: .useProtocolCachePolicy,
         timeoutInterval: 10.0
      )
      request.httpMethod = "GET"
      request.allHTTPHeaderFields = headers(for: user)
      return agent.run(request)
         .map(\.value)
         .eraseToAnyPublisher()
   }
}