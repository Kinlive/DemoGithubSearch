//
//  UsersQuery.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation

struct UsersQuery: Equatable {
  let searchText: String
  let perPage: Int
  let page: Int
}

