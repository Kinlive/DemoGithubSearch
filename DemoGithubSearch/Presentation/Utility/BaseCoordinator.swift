//
//  BaseCoordinator.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/27.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import RxSwift

class BaseCoordinator: NSObject {

  private var childCoordinators: [UUID : BaseCoordinator] = [:]
  private let identifier = UUID()

  func start() -> Completable {
    fatalError("\(#function) method should be implemented.")
  }

  private func store(coordinator: BaseCoordinator) {
    childCoordinators[coordinator.identifier] = coordinator
  }

  func free(coordinator: BaseCoordinator) {
    childCoordinators[coordinator.identifier] = nil
  }

  func coordinator(to coordinator: BaseCoordinator) -> Completable {
    store(coordinator: coordinator)

    return coordinator.start()
  }
}
