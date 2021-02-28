//
//  SearchViewModel.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import RxSwift


struct SearchViewModelInput {

}
struct SearchViewModelOutput {

}
protocol SearchViewModel {
  func transform(input: SearchViewModelInput) -> SearchViewModelOutput
}

final class DefaultSearchViewModel: SearchViewModel {

  init() {

  }

  func transform(input: SearchViewModelInput) -> SearchViewModelOutput {

    return SearchViewModelOutput()
  }
}
