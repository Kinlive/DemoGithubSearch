//
//  SearchViewController.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/27.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController: UIViewController {

  static func instantiate(viewModel: SearchViewModel) -> SearchViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
    vc.viewModel = viewModel

    return vc
  }

  @IBOutlet weak var keywordTextField: UITextField!
  @IBOutlet weak var searchButton: UIButton!

  var bag = DisposeBag()
  var viewModel: SearchViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    bindViewModel()
  }

  private func bindViewModel() {

    let keyword = keywordTextField.rx.text.orEmpty.asObservable().share()

    let input = SearchViewModelInput(
      page: Observable.just(1),
      perPage: Observable.just(8),
      keyword: keyword,
      startSearch: searchButton.rx.controlEvent(.touchUpInside).asObservable()
    )

    keywordTextField.rx.text
      .map { keyword in !(keyword?.isEmpty ?? true) }
      .bind(to: searchButton.rx.isEnabled)
      .disposed(by: bag)

    _ = viewModel.transform(input: input)
  }
}

