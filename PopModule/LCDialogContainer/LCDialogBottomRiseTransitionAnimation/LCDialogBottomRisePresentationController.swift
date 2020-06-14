//
//  LCDialogBottomRisePresentationController.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/18.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import UIKit

class LCDialogBottomRisePresentationController: UIPresentationController {
  
  var containerColor = UIColor.lcBlack.withAlphaComponent(0.75)
  
  override func presentationTransitionWillBegin() {
    if let containerView = containerView {
      containerView.insertSubview(backgroundView, at: 0)
      backgroundView.snp.makeConstraints { (make) in
        make.edges.equalTo(containerView)
      }
      excuteBackgroundAnimation()
    }
  }
  
  override func dismissalTransitionWillBegin() {
    excuteBackgroundDismissAnimation()
  }
  
  override var shouldRemovePresentersView: Bool {
    return false
  }
  
  private func excuteBackgroundAnimation() {
    backgroundView.alpha = 0
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { (_) in
        self.backgroundView.alpha = 1
      }, completion: nil)
    }
  }
  
  private func excuteBackgroundDismissAnimation() {
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { _ in
        self.backgroundView.alpha = 0
      }, completion: nil)
    }
  }
  
  // MARK: - lazy getter
  
  private lazy var backgroundView: UIView = {
    let backgroundView = UIView(frame: .zero)
    backgroundView.backgroundColor = containerColor
    backgroundView.isUserInteractionEnabled = true
    return backgroundView
  }()
}
