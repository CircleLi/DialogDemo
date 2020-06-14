//
//  LCDialogViewController.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/18.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import UIKit

class LCDialogViewController: UIViewController {
  
  enum TransitionAnimationStyle {
    /// 从中心放大
    case centerBlowUp
    /// 从底部上升
    case bottomRise
  }
  
  private let dialogView: UIView
  private let containerColor: UIColor
  private let transitionAnimation: TransitionAnimationStyle
  private let dialogLayout: (_ dialogView: UIView) -> Void
  var canTouchMaskArea: Bool = true
  var touchMaskAreaBlock: (() -> Void)?
  
  init(dialogView: UIView, containerColor: UIColor, transitionAnimation: TransitionAnimationStyle, dialogLayout:@escaping ((_ dialogView: UIView) -> Void)) {
    self.dialogView = dialogView
    self.containerColor = containerColor
    self.transitionAnimation = transitionAnimation
    self.dialogLayout = dialogLayout
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    view.addSubview(dialogView)
    self.dialogLayout(dialogView)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    if canTouchMaskArea {
      touchMaskAreaBlock?()
    }
  }

}

extension LCDialogViewController: UIViewControllerTransitioningDelegate {
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    switch transitionAnimation {
    case .centerBlowUp:
      let centerBlow = LCDialogCenterBlowUpPresentationController(presentedViewController: presented, presenting: presenting)
      centerBlow.containerColor = containerColor
      return centerBlow
    case .bottomRise:
      let bottomRise = LCDialogBottomRisePresentationController(presentedViewController: presented, presenting: presenting)
      bottomRise.containerColor = containerColor
      return bottomRise
    }
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch transitionAnimation {
    case .centerBlowUp:
      return LCDialogCenterBlowUpPresentAnimation()
    case .bottomRise:
      return LCDialogBottomRisePresentAnimation()
    }
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch transitionAnimation {
    case .centerBlowUp:
      return LCDialogCenterBlowUpDismissAnimation()
    case .bottomRise:
      return LCDialogBottomRiseDismissAnimation()
    }
  }

}
