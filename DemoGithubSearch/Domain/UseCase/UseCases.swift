//
//  UseCases.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation

protocol HasSearchUseCase {
  var searchUseCase: SearchUseCase? { get }
}

struct UseCases: HasSearchUseCase {

  var searchUseCase: SearchUseCase?

  init(
    search: SearchUseCase? = nil
  ) {
    searchUseCase = search
  }
}
