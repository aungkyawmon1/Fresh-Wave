//
//  UIViewController+Extension.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/03/2024.
//

import UIKit

extension UIViewController {
    
    func embedInNav() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
