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
  @IBOutlet weak var perPageTextField: UITextField!
  @IBOutlet weak var searchButton: UIButton!

  var bag = DisposeBag()
  var viewModel: SearchViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    bindViewModel()
  }

  private func bindViewModel() {

    let perPage = perPageTextField.rx.text.orEmpty.asObservable().share()
    let keyword = keywordTextField.rx.text.orEmpty.asObservable().share()

    let input = SearchViewModelInput(
      page: Observable.just(1),
      perPage: perPage.map { NSString(string: $0).integerValue },
      keyword: keyword,
      startSearch: searchButton.rx.controlEvent(.touchUpInside).asObservable()
    )

    Observable.combineLatest(
      perPageTextField.rx.text,
      keywordTextField.rx.text
    )
      .map { (keyword, perPage) in !(keyword?.isEmpty ?? true || perPage?.isEmpty ?? true) }
      .bind(to: searchButton.rx.isEnabled)
      .disposed(by: bag)

    let output = viewModel.transform(input: input)

    output.users
      .subscribe(onNext: { users in
        print(users)
      })
      .disposed(by: bag)

    output.headers
      .subscribe(onNext: { headers in
        print(headers)
      })
      .disposed(by: bag)
  }
}

