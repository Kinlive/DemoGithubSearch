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
  func makeSearchViewController() -> SearchViewController
}
class SearchCoordinator: BaseCoordinator {

  var navigationController: UINavigationController?
  let dependencies: SearchCoordinatorDependency

  init(navigationController: UINavigationController?, dependencies: SearchCoordinatorDependency) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }

  override func start() -> Completable {
    let subject = PublishSubject<Void>()

    let vc = dependencies.makeSearchViewController()
    vc.navigationItem.title = "Search Users"
    
    navigationController?.pushViewController(vc, animated: true)

    return subject.ignoreElements()
  }
}
