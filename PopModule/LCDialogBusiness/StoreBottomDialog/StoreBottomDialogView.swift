//
//  StoreBottomDialogView.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/20.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import UIKit

class StoreBottomDialogView: UIView {
  
  var cancelBlock: (() -> Void)?
  var gotoWebBlock: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    addSubview(safeAreaBottomView)
    addSubview(containerView)
    containerView.addSubview(gradientBgView)
    containerView.addSubview(waveImageView)
    containerView.addSubview(closeButton)
    containerView.addSubview(cupImageView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(contentLabel)
    containerView.addSubview(shadowView)
    containerView.addSubview(goPremiumButton)
    
    containerView.snp.remakeConstraints { (make) in
      make.left.right.bottom.top.equalTo(safeAreaLayoutGuide)
    }
    
    gradientBgView.snp.makeConstraints { (make) in
      make.left.top.right.equalToSuperview()
      //make.width.equalTo(UIScreen.width)
      make.height.equalTo(162)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(205)
      make.left.equalToSuperview().offset(30)
      make.right.equalToSuperview().offset(-30)
    }
    
    contentLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.left.equalToSuperview().offset(30)
      make.right.equalToSuperview().offset(-30)
    }
    
    goPremiumButton.snp.makeConstraints { (make) in
      make.top.equalTo(contentLabel.snp.bottom).offset(24)
      make.left.equalToSuperview().offset(24)
      make.right.equalToSuperview().offset(-24)
      make.height.equalTo(54)
      make.bottom.equalToSuperview().offset(-24)
    }
    
    //
    closeButton.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(5)
      make.left.equalToSuperview().offset(5)
    }
    
    waveImageView.snp.makeConstraints { (make) in
      make.edges.equalTo(gradientBgView)
    }
    
    cupImageView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(5)
      make.centerX.equalToSuperview()
    }
    
    shadowView.snp.makeConstraints { (make) in
      make.edges.equalTo(goPremiumButton)
    }
    
    safeAreaBottomView.snp.makeConstraints { (make) in
      make.top.equalTo(containerView.snp.bottom).offset(-20)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview().offset(40)
    }
  }
  
  @objc private func onCancel() {
    cancelBlock?()
  }
  
  @objc private func goPremiumAction() {
    gotoWebBlock?()
  }
  
  private lazy var containerView: UIView = {
    let containerView = UIView()
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    containerView.layer.cornerRadius = 16
    containerView.backgroundColor = .lcWhite
    containerView.clipsToBounds = true
    return containerView
  }()
  
  private lazy var safeAreaBottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .lcWhite
    return view
  }()
  
  private lazy var gradientBgView: PCGradientView = {
    let gradientBgView = PCGradientView(startColor: .color(0xFFBA00), endColor: .color(0xF6D427), startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
    //    gradientBgView.layer.cornerRadius = 16
    //    gradientBgView.layer.masksToBounds = true
    return gradientBgView
  }()
  
  private lazy var closeButton: UIButton = {
    let closeButton = UIButton(type: .custom)
    closeButton.setImage(R.image.store_bottom_close(), for: .normal)
    closeButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
    return closeButton
  }()
  
  private lazy var waveImageView: UIImageView = {
    let waveImageView = UIImageView(image: R.image.store_bottom_wave())
    return waveImageView
  }()
  
  private lazy var cupImageView: UIImageView = {
    let cupImageView = UIImageView(image: R.image.store_bottom_cup())
    return cupImageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    titleLabel.text = R.string.localizable.store_bottom_title()
    titleLabel.textColor = .color(0x1E1E1E)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    return titleLabel
  }()
  
  private lazy var contentLabel: UILabel = {
    let contentLabel = UILabel()
    contentLabel.numberOfLines = 0
    contentLabel.textAlignment = .center
    contentLabel.text = R.string.localizable.store_bottom_content()
    contentLabel.textColor = .color(0x1E1E1E)
    contentLabel.font = UIFont.systemFont(ofSize: 16)
    return contentLabel
  }()
  
  private lazy var goPremiumButton: PCGradientButton = {
    let goPremiumButton = PCGradientButton(startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5), colors: [.color(0xFFBA00), .color(0xF6D427)])
    goPremiumButton.setTitle(R.string.localizable.store_bottom_go_premium(), for: .normal)
    goPremiumButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    goPremiumButton.setTitleColor(.lcWhite, for: .normal)
    goPremiumButton.layer.cornerRadius = 8
    goPremiumButton.layer.masksToBounds = true
    goPremiumButton.addTarget(self, action: #selector(goPremiumAction), for: .touchUpInside)
    return goPremiumButton
  }()
  
  private lazy var shadowView: UIView = {
    let shadowView = UIView()
    shadowView.backgroundColor = .color(230, 196, 28)
    shadowView.layer.cornerRadius = 8
    shadowView.layer.applySketchShadow(color: .color(230, 196, 28), alpha: 0.1, x: 0, y: 12, blur: 28, spread: 0)
    return shadowView
  }()
  
}
