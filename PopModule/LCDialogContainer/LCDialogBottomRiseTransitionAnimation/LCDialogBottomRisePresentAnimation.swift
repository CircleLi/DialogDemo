//
//  LCDialogBottomRisePresentAnimation.swift
//  LingoChamp
//
//  Created by yuan li on 2020/3/18.
//  Copyright © 2020 Liulishuo iOS Group. All rights reserved.
//

import UIKit

class LCDialogBottomRisePresentAnimation: NSObject & UIViewControllerAnimatedTransitioning {
  
  struct Constant {
    static let animationDuration = 0.8
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Constant.animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.to),
      let toView = transitionContext.view( forKey: UITransitionContextViewKey.to)
      else {
        return
    }
    
    let containerView = transitionContext.containerView
    toView.frame = transitionContext.finalFrame(for: toViewController)
    containerView.addSubview(toView)
    
    toView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
    UIView.animate(withDuration: Constant.animationDuration,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 2,
                   options: .curveEaseInOut, animations: {
                    toView.transform = CGAffineTransform(translationX: 0, y: 0)
    }) { (finished) in
      transitionContext.completeTransition(finished)
    }
  }
  
}
