//
//  UIWindow+Extension.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/03/2024.
//

import UIKit

extension UIWindow {
    
    static func switchRootView(_ root: UIViewController) {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        window.rootViewController = root
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: nil, completion: nil)
    }
    
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var insets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    static var vInsets: CGFloat {
        let safe = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        return safe.top + safe.bottom
    }
}
