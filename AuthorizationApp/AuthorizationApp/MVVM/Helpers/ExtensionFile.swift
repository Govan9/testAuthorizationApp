//
//  ExtensionFile.swift
//  AuthorizationApp
//
//  Created by Admin on 13.12.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

// MARK - Hide keyboard on tap on view

extension UIViewController {
    func setupToHideKeybordOnTapOnView() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK - paint helper

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
