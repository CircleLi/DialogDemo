//
//  DMPDialogView.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/24.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import UIKit

class DMPDialogView: UIView {
  typealias Action = (() -> Void)
  
  private let content: LCDialogModel.DialogContent
  var closeAction: Action?
  var sureAction: Action?
  
  private var scale: CGFloat {
    switch content.type {
    case .STYLE_1:
      return CGFloat(489/981.0)
    case .STYLE_2:
      return CGFloat(1170/981.0)
    case .NONE:
      return CGFloat(489/981.0)
    }
  }
  
  init(content: LCDialogModel.DialogContent) {
    self.content = content
    super.init(frame: UIScreen.main.bounds)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubview(contentView)
    contentView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.left.equalToSuperview().offset(24)
    }
    
    addSubview(closeButton)
    closeButton.snp.makeConstraints { (make) in
      make.width.height.equalTo(68)
      make.centerX.equalToSuperview()
      make.top.equalTo(contentView.snp.bottom)
    }
    if content.type == .STYLE_2 {
      contentView.backgroundColor = .clear
      contentView.addSubview(imageView)
      imageView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
        make.height.equalTo(contentView.snp.width).multipliedBy(scale)
      }
      
      contentView.addSubview(sureButton)
      sureButton.backgroundColor = .lcWhite
      sureButton.setTitleColor(.lcJade, for: .normal)
      sureButton.snp.makeConstraints { (make) in
        make.left.equalToSuperview().offset(24)
        make.right.equalToSuperview().offset(-24)
        make.bottom.equalToSuperview().offset(-24)
        make.height.equalTo(48)
      }

    } else if content.type == .STYLE_1 {
      contentView.backgroundColor = .white
      contentView.addSubview(imageView)
      imageView.snp.makeConstraints { (make) in
        make.left.top.right.equalToSuperview()
        make.height.equalTo(contentView.snp.width).multipliedBy(scale)
      }
      
      sureButton.backgroundColor = .lcJade
      sureButton.setTitleColor(.lcWhite, for: .normal)
      let vstack = UIStackView(arrangedSubviews: [mainTitleLabel, subTitleLabel, sureButton])
      vstack.axis = .vertical
      vstack.alignment = .fill
      
      contentView.addSubview(vstack)
      vstack.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.left.equalToSuperview().offset(24)
        make.top.equalTo(imageView.snp.bottom).offset(20)
        make.bottom.equalToSuperview().offset(-24)
      }

      vstack.setCustomSpacing(8, after: mainTitleLabel)
      vstack.setCustomSpacing(20, after: subTitleLabel)
      vstack.setCustomSpacing(24, after: sureButton)
      sureButton.snp.makeConstraints { (make) in
        make.height.equalTo(48)
      }
    }
    if let url =  URL(string: content.coverUrl) {
      imageView.lls_setImage(with: url, completed: nil)
    }
  }
  
  // MARK: - lazy getter
  private lazy var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .lcWhite
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    return view
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setImage(R.image.iconCloseWhite29(), for: .normal)
    button.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    return button
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    return imageView
  }()
  
  private lazy var mainTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = UIColor.color(0x1e1e1e)
    label.font = R.font.gilroyBold(size: 20)
    label.textAlignment = .center
    label.text = content.title
    return label
  }()
  
  private lazy var subTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = UIColor.color(0x9f9f9f)
    label.font = R.font.gilroySemiBold(size: 14)
    label.textAlignment = .center
    label.text = content.content
    return label
  }()
  
  private lazy var sureButton: UIButton = {
    let button = UIButton()
    button.setTitle(content.buttonText, for: .normal)
    button.titleLabel?.font = R.font.gilroyBold(size: 20)
    button.addTarget(self, action: #selector(clickSureButton), for: .touchUpInside)
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    return button
  }()
  
}

// MARK: - private action
extension DMPDialogView {
  @objc private func clickCloseButton() {
    if let closeAction = closeAction {
      closeAction()
    }
  }
  
  @objc private func clickSureButton() {
    if let sureAction = sureAction {
      sureAction()
    }
  }
}
