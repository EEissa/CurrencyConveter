//
//  ViewExtenstions.swift
//  ODZ
//
//  Created by Essam on 6/21/18.
//  Copyright © 2018 Essam. All rights reserved.
//

import UIKit

extension UIView {
  func holdingViewController() -> UIViewController? {
    if let nextResponder = self.next as? UIViewController {
      return nextResponder
    } else if let nextResponder = self.next as? UIView {
      return nextResponder.holdingViewController()
    } else {
      return nil
    }
  }
  
  func shake() {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    animation.duration = 0.6
    animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
    layer.add(animation, forKey: "shake")
  }
  
  func animateTo(frame: CGRect, withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
     guard let _ = superview else {
       return
     }
  
     let xScale = frame.size.width / self.frame.size.width
     let yScale = frame.size.height / self.frame.size.height
     let x = frame.origin.x + (self.frame.width * xScale) * self.layer.anchorPoint.x
     let y = frame.origin.y + (self.frame.height * yScale) * self.layer.anchorPoint.y
    
     UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
       self.layer.position = CGPoint(x: x, y: y)
       self.transform = self.transform.scaledBy(x: xScale, y: yScale)
     }, completion: completion)
   }
  
}
