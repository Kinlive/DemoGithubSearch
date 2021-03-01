//
//  ListViewController.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

  static func instantiate(viewModel: ListViewModel) -> ListViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
    vc.viewModel = viewModel
    return vc
  }

  // MARK: - Subviews
  @IBOutlet weak var listCollectionView: UICollectionView!

  // MARK: - Properties
  private var bag = DisposeBag()
  var viewModel: ListViewModel!

  private let sectionOfUsers = BehaviorRelay<[Users]>(value: [])

  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
    configures()
  }

  private func configures() {
    listCollectionView.rx
      .setDelegate(self)
      .disposed(by: bag)
    listCollectionView.dataSource = self
    listCollectionView.register(UserCell.self, forCellWithReuseIdentifier: String(describing: type(of: UserCell.self)))
    listCollectionView.register(ListSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type(of: ListSectionHeader.self)))
    
  }

  private func bindViewModel() {

    let onScrolling = listCollectionView.rx.delegate.sentMessage(#selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .map { [weak self] _ -> CGFloat in
        guard let `self` = self else { return 0 }
        return self.listCollectionView.contentOffset.y
      }
      .filter { [weak self] _ in self?.sectionOfUsers.value.count != 0 }
      .share()

    let onScrollingToBottom = onScrolling
      .map { [weak self] offsetY in
        guard let `self` = self else { return false }
        let bottomEdge = (offsetY + self.listCollectionView.frame.height )
        return bottomEdge >= (self.listCollectionView.contentSize.height + 50)
      }
      .filter { $0 }

    let input = ListViewModelInput(
      startSearch: rx.viewWillAppear.map { _ in },
      scrollingToBottom: onScrollingToBottom
    )

    let output = viewModel.transform(input: input)

    output.sectionUsers
      .observeOn(MainScheduler.instance)
      .do(afterNext: { [weak self] _ in self?.listCollectionView.reloadData() })
      .bind(to: sectionOfUsers)
      .disposed(by: bag)

  }
}

// MARK: - UICollectionView delegate flow layout
extension ListViewController: UICollectionViewDelegateFlowLayout {
  private var xSpacing: CGFloat {
    return 5
  }
  private var ySpacing: CGFloat {
    return 10
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let item = (collectionView.frame.width - 2 * xSpacing) * 0.5
    return CGSize(width: item, height: item)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width - xSpacing * 2, height: 60)
  }

}

// MARK: - UICollectionView dataSource
extension ListViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sectionOfUsers.value.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sectionOfUsers.value[section].users.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: type(of: UserCell.self)), for: indexPath) as! UserCell

    let user = sectionOfUsers.value[indexPath.section].users[indexPath.row]
    cell.configure(user: user)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    if kind == UICollectionView.elementKindSectionHeader {
      let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: type(of: ListSectionHeader.self)), for: indexPath) as! ListSectionHeader

      sectionHeader.configure(pageNumber: indexPath.section + 1)

      return sectionHeader
    }

    return UICollectionReusableView()
  }

}
