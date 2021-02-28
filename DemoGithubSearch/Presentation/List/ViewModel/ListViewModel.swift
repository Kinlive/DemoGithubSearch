//
//  ListViewModel.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation

struct ListViewModelInput {

}
struct ListViewModelOutput {

}
protocol ListViewModel {
  func transform(input: ListViewModelInput) -> ListViewModelOutput
}

final class DefaultListViewModel: ListViewModel {

  init() {
    
  }

  func transform(input: ListViewModelInput) -> ListViewModelOutput {
    return ListViewModelOutput()
  }
}
