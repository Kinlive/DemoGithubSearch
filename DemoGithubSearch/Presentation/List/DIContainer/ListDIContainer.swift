//
//  ListDIContainer.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit

protocol ListDIContainerFactory {
  func makeListCoordinator(at navigationController: UINavigationController?) -> ListCoordinator
  func makeUseCase() -> UseCases
  func makeListViewModel() -> ListViewModel
}

class ListDIContainer: ListDIContainerFactory {

  typealias Dependencies = HasGithubService
  private let passValue: UsersQuery
  private let dependencies: Dependencies

  init(dependencies: Dependencies, passValue: UsersQuery) {
    self.dependencies = dependencies
    self.passValue = passValue
  }

  // MARK: - Factory
  func makeListCoordinator(at navigationController: UINavigationController?) -> ListCoordinator {
    return ListCoordinator(navigationController: navigationController, dependencies: self)
  }

  func makeUseCase() -> UseCases {
    let searchUseCase = DefaultSearchUseCase(dependencies: dependencies)
    return UseCases(search: searchUseCase)
  }

  func makeListViewModel() -> ListViewModel {
    return DefaultListViewModel(useCase: makeUseCase(), passValue: passValue)
  }
}

extension ListDIContainer: ListCoordinatorDependencies {
  func makeListViewController() -> ListViewController {
    return ListViewController.instantiate(viewModel: makeListViewModel())
  }
}
