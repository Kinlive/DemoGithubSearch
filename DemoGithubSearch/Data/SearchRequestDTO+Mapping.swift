//
//  SearchRequestDTO.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation

struct SearchRequestDTO: Encodable {
  let text: String
  let perPage: Int
  let page: Int
  let order: String

  enum CodingKeys: String, CodingKey {
    case text = "q"
    case perPage = "per_page"
    case page
    case order
  }

  init(query: UsersQuery) {
    text = query.searchText
    perPage = query.perPage
    page = query.page
    order = "sort"
  }
}

extension SearchRequestDTO {
  func toDomain() -> UsersQuery {
    return UsersQuery(
      searchText: text,
      perPage: perPage,
      page: page
    )
  }
}

extension UsersQuery {
  func toDTO() -> SearchRequestDTO {
    return SearchRequestDTO(query: self)
  }
}
