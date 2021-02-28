//
//  SearchViewController.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/27.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  static func instantiate(viewModel: SearchViewModel) -> SearchViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
    vc.viewModel = viewModel
    vc.bindViewModel()
    return vc
  }

  var viewModel: SearchViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

  }

  private func bindViewModel() {

  }
}

