//
//  HeadersFieldDTO.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation

struct HeadersField {

  enum Rel {
    case first
    case prev
    case next
    case last

    init?(rawValue: String) {
      switch rawValue {
      case "first": self = .first
      case "prev": self = .prev
      case "next": self = .next
      case "last": self = .last
      default: return nil
      }
    }

  }

  let text: String
  let perPage: Int
  let page: Int
  let rel: Rel

}
