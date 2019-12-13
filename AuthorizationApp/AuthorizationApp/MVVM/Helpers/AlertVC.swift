//
//  AlertVC.swift
//  AuthorizationApp
//
//  Created by Admin on 13.12.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class AlertVC: NSObject {
    
    static let sharedInstace = AlertVC()
    
    func createAlert(view: UIViewController, title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true, completion: nil)
        })
    }
}

