//
//  AppDependency.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation

protocol HasGithubService {
  var githubService: GithubService<GithubAPI> { get }
}
struct AppDependency: HasGithubService {

  var githubService: GithubService<GithubAPI>

  init(service: GithubService<GithubAPI>) {
    self.githubService = service
  }
}
