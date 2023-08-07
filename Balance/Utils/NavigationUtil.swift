//
//  NavigationUtil.swift
//  Balance
//
//  Created by Gonzalo Perisset on 24/04/2023.
//

import SwiftUI

// swiftlint:disable all
enum NavigationUtil {
    static func dismiss(_ n: Int) {
        let rootViewController = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map {$0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter({ $0.isKeyWindow }).first?.rootViewController
        guard let rootViewController = rootViewController else { return }
        
        var leafFlound = false
        var viewStack: [UIViewController] = [rootViewController]
        while(!leafFlound) {
            if let presentedViewController = viewStack.last?.presentedViewController {
                viewStack.append(presentedViewController)
            } else {
                leafFlound = true
            }
        }
        let presentingViewController = viewStack[max(0, viewStack.count - n - 1)]
        presentingViewController.dismiss(animated: true)
    }
    
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
