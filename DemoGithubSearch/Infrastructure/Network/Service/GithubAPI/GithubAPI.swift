//
//  GithubAPI.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import Moya

enum GithubAPI {
  case searchUsers(query: UsersQuery)
}

extension GithubAPI: TargetType {
  var baseURL: URL {
    URL(string: "https://api.github.com")!
  }

  var path: String {
    switch self {
    case .searchUsers: return "/search/users"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var sampleData: Data {
    return "{}".data(using: .utf8)!
  }

  var task: Task {
    switch self {
    case .searchUsers(let query):
      let dto = query.toDTO()
      let dic = (try? dto.toDictionary()) ?? [:]

      return .requestParameters(parameters: dic, encoding: URLEncoding.queryString)
    }
  }

  var headers: [String : String]? {
    [
      "accept" : "application/vnd.github.v3+json"
    ]
  }


}
