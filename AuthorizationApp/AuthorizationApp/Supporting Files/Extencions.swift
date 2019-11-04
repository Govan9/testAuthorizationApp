//
//  Extencions.swift
//  Authorization
//
//  Created by Admin on 30.10.2019.
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

// MARK - Validation check of email and password

extension String {
    
    enum ValidType {
        case email
        case password
    }
    
    enum Regex: String {
        case email = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?+@([A-Z0-9a-z]([A-Z0-9a-z]{0,30}[A-Z0-9a-z])?\\.){1,5}[A-Za-z]{2,8}"
        case password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9]{6,64}"
    }
    
    func isValid(_ validType: ValidType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .email:
            regex = Regex.email.rawValue
        case .password:
            regex = Regex.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}

// MARK - paint helper

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
