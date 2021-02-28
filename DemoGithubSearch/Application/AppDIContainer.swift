//
//  AppDIContainer.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/27.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation

protocol AppDIContainerFactory {
  func makeSearchDIContainer() -> SearchDIContainer
}

class AppDIContainer: AppDIContainerFactory {

  init() {
    
  }

  func makeSearchDIContainer() -> SearchDIContainer {
    return SearchDIContainer(dependencies: AppDependency())
  }
}
