//
//  ListViewModel.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import RxSwift

struct ListViewModelInput {
  let startSearch: Observable<Void>
  let scrollingToBottom: Observable<Bool>
}
struct ListViewModelOutput {
  let sectionUsers: Observable<[Users]>
}

protocol ListViewModel {
  func transform(input: ListViewModelInput) -> ListViewModelOutput
}

final class DefaultListViewModel: ListViewModel {

  typealias UseCase = HasSearchUseCase
  private let useCase: UseCase
  private let passValue: UsersQuery
  private let bag = DisposeBag()

  init(useCase: UseCase, passValue: UsersQuery) {
    self.useCase = useCase
    self.passValue = passValue
  }

  func transform(input: ListViewModelInput) -> ListViewModelOutput {

    // first request result
    let result = input.startSearch
      .map { [unowned self] _ in self.passValue }
      .flatMap { [weak self] query in
        return self?.searchUseCase(query: query) ?? .empty()
      }
      .share()

    // prepare subject for next page
    let nextHeaders = PublishSubject<[HeadersField]>()

    // combine two headers
    let eachHeaderUpdate = Observable.merge(
      result.map { $0.headers },
      nextHeaders.asObservable()
    )
      .share()

    // request next page when user scrolling to bottom
    let nextPageQuery = input.scrollingToBottom.withLatestFrom(eachHeaderUpdate)
      .map { headers in headers.filter { $0.rel == .next }.first }
      .filter { $0 != nil }.map { $0! }
      .map { header in
        // transfer header to next page's query
        UsersQuery(
          searchText: header.text,
          perPage: header.perPage,
          page: header.page
        )
      }
      .flatMap { [weak self] query in
        return self?.searchUseCase(query: query) ?? .empty()
      }
      .share()

    // sync header when fetched new
    nextPageQuery
      .map { $0.headers }
      .subscribe(onNext: { nextHeaders.onNext($0) })
      .disposed(by: bag)

    // increase users
    let combinedUsers = Observable.merge(
      result.map { $0.users },
      nextPageQuery.map { $0.users }
    )
      .scan([]) { (sum, nextUsers) -> [Users] in
        return sum + [nextUsers]
    }

    return ListViewModelOutput(
      sectionUsers: combinedUsers
    )
  }

  private func searchUseCase(query: UsersQuery) -> Observable<UsersAndHeaders> {
    guard let searchUseCase = useCase.searchUseCase else {
      return .error(NSError(domain: "Not found the useCase of search", code: 998, userInfo: nil)) }

    return searchUseCase.search(query: query)
  }
}
