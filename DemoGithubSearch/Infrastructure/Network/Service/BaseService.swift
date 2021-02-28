//
//  BaseService.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import Moya

protocol BaseService {

  associatedtype TargetTypeBase: TargetType
  associatedtype ReturnValueBase
  associatedtype CancellableBase

  var provider: MoyaProvider<TargetTypeBase> { get }
  init(provider: MoyaProvider<TargetTypeBase>)

  @discardableResult
  func request(targetType: TargetTypeBase, completion: @escaping (ReturnValueBase) -> Void) -> CancellableBase
}
