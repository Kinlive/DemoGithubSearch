//
//  ListSectionHeader.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/3/1.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit

class ListSectionHeader: UICollectionReusableView {

  var pageLabel: UILabel = {

    let label: UILabel = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .systemOrange
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
    label.sizeToFit()
    return label
  }()


  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(pageLabel)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    pageLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    pageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    pageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
    pageLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -15).isActive = true
  }

  func configure(pageNumber: Int) {
    pageLabel.text = "第 \(pageNumber) 頁"
  }
}
