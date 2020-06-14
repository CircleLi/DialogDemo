//
//  LCDialogBottomRiseDismissAnimation.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/18.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import UIKit

class LCDialogBottomRiseDismissAnimation: NSObject & UIViewControllerAnimatedTransitioning {
  
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
                    fromView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
                    fromView.alpha = 0.0
    }) { (finished) in
      fromView.transform = CGAffineTransform(translationX: 0, y: 0)
      fromView.alpha = 1.0
      transitionContext.completeTransition(finished)
    }
  }
  
}
