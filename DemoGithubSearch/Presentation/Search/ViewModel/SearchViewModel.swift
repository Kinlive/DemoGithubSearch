//
//  SearchViewModel.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import RxSwift


struct SearchActions {
  let showList: (UsersQuery) -> Void
}
struct SearchViewModelInput {
  let page: Observable<Int>
  let perPage: Observable<Int>
  let keyword: Observable<String>
  let startSearch: Observable<Void>
}

struct SearchViewModelOutput {
}
protocol SearchViewModel {
  func transform(input: SearchViewModelInput) -> SearchViewModelOutput
}

final class DefaultSearchViewModel: SearchViewModel {

  typealias UseCase = HasSearchUseCase

  private let useCases: UseCase
  private let actions: SearchActions
  private let bag = DisposeBag()

  init(useCases: UseCase, actions: SearchActions) {
    self.useCases = useCases
    self.actions = actions
  }

  func transform(input: SearchViewModelInput) -> SearchViewModelOutput {

    Observable.combineLatest(
      input.perPage,
      input.keyword,
      input.page
    )
      .sample(input.startSearch)
      .map { perPage, keyword, page in UsersQuery(searchText: keyword, perPage: perPage, page: page) }
      .subscribe(onNext: { [weak self] query in
        self?.actions.showList(query)
      })
      .disposed(by: bag)

    return SearchViewModelOutput()
  }

  private func searchUseCase(query: UsersQuery) -> Observable<UsersAndHeaders> {
    guard let searchUseCase = useCases.searchUseCase else {
      return .error(NSError(domain: "Not found the useCase of search", code: 998, userInfo: nil)) }

    return searchUseCase.search(query: query)
  }
}
