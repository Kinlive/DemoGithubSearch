//
//  Users.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation

struct Users: Equatable {
  let totalCount: Int
  let users: [User]
}


struct User: Equatable {
  let accountName: String
  let avatarURL: String
  let id: Int
}

