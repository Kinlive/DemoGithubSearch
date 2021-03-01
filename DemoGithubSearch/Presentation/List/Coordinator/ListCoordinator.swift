//
//  ListCoordinator.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit
import RxSwift

protocol ListCoordinatorDependencies {
  func makeListViewController() -> ListViewController
}
class ListCoordinator: BaseCoordinator {

  private weak var navigationController: UINavigationController?
  private let dependencies: ListCoordinatorDependencies

  init(navigationController: UINavigationController?, dependencies: ListCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }

  override func start() -> Completable {
    let subject = PublishSubject<Void>()
    let vc = dependencies.makeListViewController()
    vc.navigationItem.title = "List"
    navigationController?.pushViewController(vc, animated: true)

    return subject.ignoreElements()
  }
}
