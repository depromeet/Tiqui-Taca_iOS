//
//  UINavigationController+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/02.
//

import UIKit
import Foundation

extension UINavigationController: UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
