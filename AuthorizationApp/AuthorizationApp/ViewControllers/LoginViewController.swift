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
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var emailTextField: MatetialTextField!
    @IBOutlet weak var passwordTextField: MatetialTextField!
    @IBOutlet weak var emptyButtonSecond: UIButton!
    
    
    var weatherResponse = WeatherResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Авторизация"
        
        setupEnterButton()
        setupTextField()
        
        setupSecondEmptyButton()
        
        registerForKeyboardNotification()
        setupToHideKeybordOnTapOnView()
        
        checkTextFieldIsEmpty()
        
        validationCheck()

        passwordTextField.setupRightButton()
        
        setupMessageView()
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
            UIView.animate(withDuration: 0.3, animations: {
                self.enterButton.backgroundColor = UIColor.rgb(red: 255, green: 155, blue: 0)
                self.enterButton.isEnabled = true
            })
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
        
        let (valid, message) = validateTextField(emailTextField)
        
        if text.isValid(.email) {
            print("Valid text")
            emailTextField.textColor = .black
            
            UIView.animate(withDuration: 0.3, animations: {
                self.emailTextField.messageLabel.isHidden = valid
            })
        } else {
            emailTextField.textColor = .red

            emailTextField.messageLabel.text = message
            UIView.animate(withDuration: 0.3, animations: {
                self.emailTextField.messageLabel.isHidden = valid
                self.emailTextField.messageLabel.textColor = .red
            })
        }
    }
    
    @objc func handlePasswordChange() {
        guard let text = passwordTextField.text else { return }
        
        let (valid, message) = validateTextField(passwordTextField)
        
        if text.isValid(.password) {
            passwordTextField.textColor = .black
            
            UIView.animate(withDuration: 0.3, animations: {
                self.passwordTextField.messageLabel.isHidden = valid
            })
        } else {
            passwordTextField.textColor = .red
            
            passwordTextField.messageLabel.text = message
            UIView.animate(withDuration: 0.3, animations: {
                self.passwordTextField.messageLabel.isHidden = valid
                self.passwordTextField.messageLabel.textColor = .red
            })
        }
    }
    
    // validation identifier message show helper
    func validateTextField(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        if textField == emailTextField {
            
            if text.isEmpty {
                return (!text.isEmpty, "Это поле не может быть пустым")
            } else {
                return (text.isValid(.email), "Не корректная почта")
            }
        }
        
        if textField == passwordTextField {
            if text.isEmpty {
                return (!text.isEmpty, "Это поле не может быть пустым")
            } else {
                return (text.isValid(.password), "Не корректный пароль")
            }
        }
        
        return (false, nil)
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
    
    // MARK - setup
    
    func setupEnterButton() {
        enterButton.setTitle("Войти", for: .normal)
        enterButton.layer.cornerRadius = 22
        enterButton.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
    }

    func setupTextField() {
        emailTextField.placeholder = "Почта"
        emailTextField.placeholderColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1)
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = UIColor.clear
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.placeholderColor = UIColor.rgb(red: 121, green: 121, blue: 121)
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.isSecureTextEntry = true
    }
    
    func setupSecondEmptyButton() {
        emptyButtonSecond.setTitle("У мня еще нет аккаунта. Создать.", for: .normal)
        emptyButtonSecond.tintColor = UIColor.rgb(red: 56, green: 133, blue: 199)
        emptyButtonSecond.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func setupMessageView() {
        emailTextField.messageLabel.isHidden = true
        passwordTextField.messageLabel.isHidden = true
    }
}
