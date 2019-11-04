//
//  ViewController.swift
//  Authorization
//
//  Created by Admin on 24.10.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 22
        startButton.setTitle("Авторизация", for: .normal)
        startButton.layer.backgroundColor = UIColor.rgb(red: 255, green: 155, blue: 0).cgColor
        startButton.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.rgb(red: 74, green: 144, blue: 226)
        navigationItem.backBarButtonItem = backItem
    }
}

