//
//  SearchUseCase.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import RxSwift

typealias UsersAndHeaders = (users: Users, headers: [HeadersField])
protocol SearchUseCase {
  func search(query: UsersQuery) -> Observable<UsersAndHeaders>
}

final class DefaultSearchUseCase: SearchUseCase {

  typealias Dependencies = HasGithubService

  let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  func search(query: UsersQuery) -> Observable<UsersAndHeaders> {
    return Observable.create { [weak self] observer -> Disposable in
      self?.dependencies.githubService.request(targetType: .searchUsers(query: query)) { result in
        if let error = result.error {
          observer.onError(error)
          return
        }

        guard let responseDTO = result.responseDTO else {
          observer.onError(NSError(domain: "responseDTO nil", code: 999, userInfo: nil))
          return
        }

        observer.onNext((responseDTO.toDomain(), result.headerField))
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}
