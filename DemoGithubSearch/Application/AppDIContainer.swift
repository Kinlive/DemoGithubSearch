//
//  AppDIContainer.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/27.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import Moya

protocol AppDIContainerFactory {
  func makeSearchDIContainer() -> SearchDIContainer
}

class AppDIContainer: AppDIContainerFactory {

  init() {
    
  }

  func makeSearchDIContainer() -> SearchDIContainer {

    let service = GithubService<GithubAPI>(provider: MoyaProvider())
    return SearchDIContainer(dependencies: AppDependency(service: service))
  }
}
