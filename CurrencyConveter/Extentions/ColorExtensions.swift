//
//  ColorExtensions.swift
//  Hrafyeen
//
//  Created by Essam on 10/29/19.
//  Copyright © 2019 Essam. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect:CGRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image! // was image
    }
}
