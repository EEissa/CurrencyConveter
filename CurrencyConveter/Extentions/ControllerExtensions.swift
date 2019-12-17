//
//  ControllerExtension.swift
//  PickwPost
//
//  Created by Essam on 11/1/18.
//  Copyright © 2018 Cyper Accounting. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
  class func topMost() -> UIViewController? {
    var topController = UIApplication.shared.keyWindow?.rootViewController
      while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
      }
      return topController
  }
  
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  func showHud() {
    MBProgressHUD.showAdded(to: view, animated: true)
  }
  
  func showHud(_ controller: UIViewController ) {
    MBProgressHUD.showAdded(to: controller.view, animated: true)
  }
  
  func hideHud(_ controller: UIViewController ) {
    MBProgressHUD.hideAllHUDs(for: controller.view, animated: true)
  }
  
  func showHud(_ message: String) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.detailsLabel.text = message
  }
  
  func hideHud() {
    MBProgressHUD.hide(for: view, animated: true)
  }
  
  func show(errorAlert error: NSError) {
    show(error.localizedDescription)
  }
  
  func show(messageAlert title: String, message: String? = "", actionTitle: String? = nil, action: ((UIAlertAction) -> Void)? = nil) {
    show(title, message: message, actionTitle: actionTitle, action: action)
  }
  
  fileprivate func show(_ title: String,  message: String? = "", actionTitle: String? = nil , action: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    if let _actionTitle = actionTitle {
      alert.addAction(UIAlertAction(title: _actionTitle , style: .default, handler: action))
    }
    
    alert.addAction(UIAlertAction(title:"close" , style: .cancel,  handler: action))

    present(alert, animated: true, completion: nil)
  }
  
  func add(asChildViewController viewController: UIViewController, atView view: UIView, child: Bool? = nil) {
    if child == nil { viewController.addChild(self) }
    viewController.addChild(self)
    self.view.frame = view.bounds
    view.addSubview(self.view)
    view.bringSubviewToFront(self.view)
    self.view.autoresizingMask = [ .flexibleLeftMargin,
                                   .flexibleWidth,
                                   .flexibleRightMargin,
                                   .flexibleTopMargin,
                                   .flexibleHeight,
                                   .flexibleBottomMargin]
    self.didMove(toParent: viewController)
  }
  
  func removeChildViewController() {
    self.willMove(toParent: nil)
    self.view.removeFromSuperview()
    self.removeFromParent()
  }
  
}


