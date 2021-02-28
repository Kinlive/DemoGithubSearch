//
//  AppFlowCoordinator.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/27.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit
import RxSwift

class AppFlowCoordinator: BaseCoordinator {

  private let bag = DisposeBag()

  private let window: UIWindow?

  let appDIContainer: AppDIContainer

  init(window: UIWindow?, appDIContainer: AppDIContainer) {
    self.window = window
    self.appDIContainer = appDIContainer
  }

  override func start() -> Completable {
    let navigationController = UINavigationController()
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    let subContainer = appDIContainer.makeSearchDIContainer()
    let subCoordinator = subContainer.makeSearchCoordinator(at: navigationController)

    coordinator(to: subCoordinator)
      .subscribe()
      .disposed(by: bag)

    return .never()
  }
}
