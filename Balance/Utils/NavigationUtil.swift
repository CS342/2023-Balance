//
//  NavigationUtil.swift
//  Balance
//
//  Created by Gonzalo Perisset on 24/04/2023.
//

import SwiftUI

enum NavigationUtil {
  static func popToRootView() {
      findNavigationController(viewController: UIApplication.shared.currentUIWindow()?.rootViewController)?
      .popToRootViewController(animated: true)
  }

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }
}
