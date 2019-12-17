//
//  ArrayExtentions.swift
//  PickwPost
//
//  Created by Essam on 11/1/18.
//  Copyright © 2018 Cyper Accounting. All rights reserved.
//
import UIKit

extension Array {
  func containSameElements<T: Comparable>(_ array: [T]) -> Bool {
    guard self.count == array.count else {
      return false
    }
    
    return (self as! [T]).sorted() == array.sorted()
  }
}
