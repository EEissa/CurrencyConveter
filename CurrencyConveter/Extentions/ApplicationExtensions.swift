//
//  ApplicationExtensions.swift
//  Hrafyeen
//
//  Created by Essam on 10/27/19.
//  Copyright © 2019 Essam. All rights reserved.
//

import UIKit

extension UIApplication {
var statusBarUIView: UIView? {
    if #available(iOS 13.0, *) {
        let tag = 38482
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            return nil
//            guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
//            let statusBarView = UIView(frame: statusBarFrame)
//            statusBarView.tag = tag
//            keyWindow?.addSubview(statusBarView)
//            return statusBarView
        }
    } else if responds(to: Selector(("statusBar"))) {
        return value(forKey: "statusBar") as? UIView
    } else {
        return nil
    }
  }
}
