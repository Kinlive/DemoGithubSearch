//
//  UserCell.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/3/1.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import UIKit
import Kingfisher

class UserCell: UICollectionViewCell {

  // MARK: - Subviews
  lazy var photoImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    //image.contentMode = .scaleToFill
    return image
  }()

  lazy var titleBaseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

    return view
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white

    return label
  }()

  // MARK: - Properties

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubviews()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    photoImageView.image = nil
    titleLabel.text = nil
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    makeUIsConstraints()
    setupUI()
  }

  // MARK: - Make UIs
  private func addSubviews() {
    contentView.addSubview(photoImageView)
    contentView.addSubview(titleBaseView)
    contentView.addSubview(titleLabel)
  }

  private func makeUIsConstraints() {
    // Photo
    photoImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
    photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
    photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    // Title base view
    titleBaseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    titleBaseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    titleBaseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    titleBaseView.heightAnchor.constraint(equalToConstant: 40).isActive = true

    // title
    titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    titleLabel.topAnchor.constraint(equalTo: titleBaseView.topAnchor, constant: 10).isActive = true
    titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: titleBaseView.bottomAnchor, constant: 5).isActive = true

  }

  private func setupUI() {
    photoImageView.layer.cornerRadius = photoImageView.frame.height * 0.5
    photoImageView.layer.masksToBounds = true
  }

  func configure(user: User) {
    titleLabel.text = user.accountName

    let url = URL(string: user.avatarURL)
    photoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
  }
}
