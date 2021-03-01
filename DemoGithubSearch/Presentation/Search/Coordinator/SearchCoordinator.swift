//
//  SearchCoordinator.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchCoordinatorDependency {
  func makeSearchViewController(actions: SearchActions) -> SearchViewController
  func makeListDIContainer(passValue: UsersQuery) -> ListDIContainer
}
class SearchCoordinator: BaseCoordinator {

  var navigationController: UINavigationController?
  let dependencies: SearchCoordinatorDependency
  private let bag = DisposeBag()

  init(navigationController: UINavigationController?, dependencies: SearchCoordinatorDependency) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }

  override func start() -> Completable {
    let subject = PublishSubject<Void>()
    let actions = SearchActions { [weak self] usersQuery in
      guard let `self` = self else { return }
      // when user tapped search button pass query data to next page.
      let listDIContainer = self.dependencies.makeListDIContainer(passValue: usersQuery)
      let listCoordinator = listDIContainer.makeListCoordinator(at: self.navigationController)
      self.coordinator(to: listCoordinator).asObservable()
        .map { _ in }
        .bind(to: subject)
        .disposed(by: self.bag)
    }
    
    let vc = dependencies.makeSearchViewController(actions: actions)
    vc.navigationItem.title = "Search Users"
    
    navigationController?.pushViewController(vc, animated: true)

    return subject.ignoreElements()
  }

}
