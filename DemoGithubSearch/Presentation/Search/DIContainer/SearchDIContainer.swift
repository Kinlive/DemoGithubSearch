//
//  SearchDIContainer.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit

protocol SearchDIContainerFactory {
  func makeSearchCoordinator(at navigationController: UINavigationController) -> SearchCoordinator
  func makeSearchViewModel() -> SearchViewModel
}

class SearchDIContainer: SearchDIContainerFactory {

  typealias Dependencies = AppDependency
  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  func makeSearchCoordinator(at navigationController: UINavigationController) -> SearchCoordinator {
    return SearchCoordinator(navigationController: navigationController, dependencies: self)
  }

  func makeSearchViewModel() -> SearchViewModel {
    return DefaultSearchViewModel()
  }
}

extension SearchDIContainer: SearchCoordinatorDependency {
  func makeSearchViewController() -> SearchViewController {
    return SearchViewController.instantiate(viewModel: makeSearchViewModel())
  }
}
