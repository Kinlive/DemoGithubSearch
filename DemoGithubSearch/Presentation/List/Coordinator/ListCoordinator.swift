//
//  ListCoordinator.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import RxSwift

class ListCoordinator: BaseCoordinator {

  override init() {

  }

  override func start() -> Completable {
    let subject = PublishSubject<Void>()

    return subject.ignoreElements()
  }
}
