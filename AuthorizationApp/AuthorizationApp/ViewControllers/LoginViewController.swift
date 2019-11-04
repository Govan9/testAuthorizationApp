//
//  LoginViewController.swift
//  Authorization
//
//  Created by Admin on 25.10.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emptyButtonFirst: UIButton!
    @IBOutlet weak var emptyButtonSecond: UIButton!
    
    var weatherResponse = WeatherResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Авторизация"
        
        setupLables()
        setupEnterButton()
        setupTextField()
        setupFirstEmptyButton()
        setupSecondEmptyButton()
        
        registerForKeyboardNotification()
        setupToHideKeybordOnTapOnView()
        
        checkTextFieldIsEmpty()
        
        validationCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        weatherResponse.currentWeather()
    }
    
    // MARK - can enterButton make next step?
    
    func checkTextFieldIsEmpty() {
        
        if emailTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true {
            enterButton.isEnabled = false
            enterButton.backgroundColor = UIColor.rgb(red: 208, green: 155, blue: 0)
            print ("Empty")
        }
    }

    func changeStatusEntryButton() {
        if enterButton.backgroundColor == UIColor.rgb(red: 208, green: 155, blue: 0) && enterButton.isEnabled == false {
            enterButton.backgroundColor = UIColor.rgb(red: 255, green: 155, blue: 0)
            enterButton.isEnabled = true
        }
    }
    
    // MARK - send request and create alert

    @IBAction func showAlertButtonTapped(_ sender: UIButton) {
        
        // create alert and filling out it
        let title = "Погода в городе \(weatherResponse.name)"
        let message = "Температура: " + String(format: "%.1f", weatherResponse.temp) + "C'" + "\nВлажность: " + "\(weatherResponse.humidity)" + "%" + "\nАтмосферное давление: " + "\(weatherResponse.pressure)" + "мм рт. ст."
        
        AlertViewController.sharedInstace.createAlert(view: self, title: title, message: message)
        
    }
    
    // MARK - validation check of email and password
    
    func validationCheck() {
        
        emailTextField.placeholder = "Введите логин ..."
        passwordTextField.placeholder = "Введите пароль ..."
        
        emailTextField.addTarget(self, action: #selector(handleEmailChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handlePasswordChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
    }

    // active or not enterButton
    @objc func handleChange() {
        guard let textEmail = emailTextField.text else { return }
        guard let textPassword = passwordTextField.text else { return }
        
        if textEmail.isValid(.email) && textPassword.isValid(.password) {
            
            changeStatusEntryButton()
        } else {
            
            enterButton.backgroundColor = UIColor.rgb(red: 208, green: 155, blue: 0)
            enterButton.isEnabled = false
        }
    }
    
    // validation identifier
    @objc func handleEmailChange() {
        guard let text = emailTextField.text else { return }
        
        if text.isValid(.email) {
            print("Valid text")
            emailTextField.textColor = .black
        } else {
            emailTextField.textColor = .red
        }
    }
    
    @objc func handlePasswordChange() {
        guard let text = passwordTextField.text else { return }
        if text.isValid(.password) {
            passwordTextField.textColor = .black
        } else {
            passwordTextField.textColor = .red
        }
    }
    
    // MARK - update content position
    
    deinit {
        removeKeyboardNotification()
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print("kbHight = \(kbFrameSize.height)")
        scrollView.contentOffset = CGPoint(x: 0, y: (kbFrameSize.height)/3)
    }
    
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    // MARK -
    
    func setupLables () {
        emailLabel.text = "Почта"
        passwordLabel.text = "Пароль"
        
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailLabel.textColor = UIColor.rgb(red: 121, green: 121, blue: 121)

        passwordLabel.font = UIFont.systemFont(ofSize: 13)
        passwordLabel.textColor = UIColor.rgb(red: 121, green: 121, blue: 121)
    }
    
    func setupEnterButton() {
        enterButton.setTitle("Войти", for: .normal)
        enterButton.layer.cornerRadius = 22
        enterButton.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
    }
    
    func setupTextField() {
        emailTextField.backgroundColor = UIColor.clear
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.isSecureTextEntry = true
    }
    
    func setupFirstEmptyButton() {
        emptyButtonFirst.backgroundColor = UIColor.clear
        emptyButtonFirst.layer.borderWidth = 1.0
        emptyButtonFirst.layer.cornerRadius = 4
        emptyButtonFirst.layer.borderColor = UIColor.rgb(red: 234, green: 234, blue: 234).cgColor
        emptyButtonFirst.setTitle("Забыли пароль?", for: .normal)
        emptyButtonFirst.tintColor = UIColor.rgb(red: 121, green: 121, blue: 121)
        emptyButtonFirst.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setupSecondEmptyButton() {
        emptyButtonSecond.setTitle("У мня еще нет аккаунта. Создать.", for: .normal)
        emptyButtonSecond.tintColor = UIColor.rgb(red: 56, green: 133, blue: 199)
        emptyButtonSecond.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
}
