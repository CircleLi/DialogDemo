//
//  LCDialogCenterBlowUpDismissAnimation.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/18.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import UIKit

class LCDialogCenterBlowUpDismissAnimation: NSObject & UIViewControllerAnimatedTransitioning {
  
  struct Constant {
    static let animationDuration = 0.5
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Constant.animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromView = transitionContext.view( forKey: UITransitionContextViewKey.from) else { return }
    
    UIView.animate(withDuration: Constant.animationDuration,
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
                    /*
                     这里有坑，如果这里使用CGAffineTransform(scaleX: 0, y: 0)
                     会导致动画无法生效，可能是Spring动画导致的？换成其他动画就没问题了
                     */
                    fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    fromView.alpha = 0.0
    }) { (finished) in
      fromView.transform = .identity
      fromView.alpha = 1.0
      transitionContext.completeTransition(finished)
    }
  }
  
}
