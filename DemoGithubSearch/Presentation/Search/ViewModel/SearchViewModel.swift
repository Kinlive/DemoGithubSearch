//
//  SearchViewModel.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import RxSwift


struct SearchViewModelInput {
  let page: Observable<Int>
  let perPage: Observable<Int>
  let keyword: Observable<String>
  let startSearch: Observable<Void>
}

struct SearchViewModelOutput {
  let users: Observable<Users>
  let headers: Observable<[HeadersField]>
}
protocol SearchViewModel {
  func transform(input: SearchViewModelInput) -> SearchViewModelOutput
}

final class DefaultSearchViewModel: SearchViewModel {

  typealias UseCase = HasSearchUseCase

  let useCases: UseCase

  init(useCases: UseCase) {
    self.useCases = useCases
  }

  func transform(input: SearchViewModelInput) -> SearchViewModelOutput {

    let searched = Observable.combineLatest(
      input.perPage,
      input.keyword,
      input.page
    )
      .sample(input.startSearch)
      .map { perPage, keyword, page in UsersQuery(searchText: keyword, perPage: perPage, page: page) }
      .flatMap { [weak self] query in self?.searchUseCase(query: query) ?? .empty() }
      .share()

    let users = searched.map { $0.users }
    let headers = searched.map { $0.headers }

    return SearchViewModelOutput(users: users, headers: headers)
  }

  private func searchUseCase(query: UsersQuery) -> Observable<UsersAndHeaders> {
    guard let searchUseCase = useCases.searchUseCase else {
      return .error(NSError(domain: "Not found the useCase of search", code: 998, userInfo: nil)) }

    return searchUseCase.search(query: query)
  }
}
