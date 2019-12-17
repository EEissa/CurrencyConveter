//
//  ButtonExtension.swift
//  PWPBookKeeping
//
//  Created by Essam on 12/24/18.
//  Copyright © 2018 Essam. All rights reserved.
//

import UIKit

enum NavigationItemLocation {
  case left
  case right
}

extension UIButton {
  
  open override var isEnabled: Bool {
    didSet {
      self.alpha = isEnabled ? 1 : 0.5
    }
  }
  
  convenience init(_ image: UIImage?, title: String?) {
    
    self.init(type: .custom)
    if let buttonImage = image {
      setImage(buttonImage, for: .normal)
      
    }
    
    if let buttonTitle = title {
      setTitle(buttonTitle, for: .normal)
    }
  }
  
  func centerVertically(padding: CGFloat = 6.0) {
    guard
      let imageViewSize = self.imageView?.frame.size,
      let titleLabelSize = self.titleLabel?.frame.size else {
        return
    }
    
    let totalHeight = imageViewSize.height + titleLabelSize.height + padding
    
    self.imageEdgeInsets = UIEdgeInsets(
      top: -(totalHeight - imageViewSize.height),
      left: 0.0,
      bottom: 0.0,
      right: -titleLabelSize.width
    )
    
    self.titleEdgeInsets = UIEdgeInsets(
      top: 0.0,
      left: -imageViewSize.width,
      bottom: -(totalHeight - titleLabelSize.height),
      right: 0.0
    )
    
    self.contentEdgeInsets = UIEdgeInsets(
      top: 0.0,
      left: 0.0,
      bottom: titleLabelSize.height,
      right: 0.0
    )
  }
  
  
  func addToNavigationItem(_ navigationItem: UINavigationItem?, location: NavigationItemLocation) {
    let barButton = UIBarButtonItem(customView: self)
    if location == .left {
      navigationItem?.leftBarButtonItems?.append(barButton)
    } else {
      navigationItem?.rightBarButtonItems?.append(barButton)
    }
  }
}


class ClosureSleeve {
  let closure: ()->()
  init (_ closure: @escaping ()->()) {
    self.closure = closure
  }
  @objc func invoke () {
    closure()
  }
}

extension UIControl {
  func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
    let sleeve = ClosureSleeve(closure)
    addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
  }
}
