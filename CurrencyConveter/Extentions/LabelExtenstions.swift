//
//  LabelExtenstions.swift
//  PickwPost
//
//  Created by Essam on 11/1/18.
//  Copyright © 2018 Cyper Accounting. All rights reserved.
//

import UIKit

extension UITextField {
  var isEmpty: Bool {
    return self.text?.isEmpty ?? false
  }
    
}

extension UITextView {
  var isEmpty: Bool {
    return self.text?.isEmpty ?? false
  }
  
}
