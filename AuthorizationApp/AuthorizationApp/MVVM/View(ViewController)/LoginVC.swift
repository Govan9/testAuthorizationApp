//
//  LoginVC.swift
//  AuthorizationApp
//
//  Created by Admin on 12.12.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: MatetialTextfield!
    @IBOutlet weak var passwordTextField: MatetialTextfield!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var emptyButton: UIButton!
    
    var loginViewModel = LoginViewModel()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Авторизация"
        
        validationForm()
        
        passwordTextField.setupRightButton()
        
        registerForKeyboardNotification()
        setupToHideKeybordOnTapOnView()
        
        setupTextField()
        setupEnterButton()
        setupEmptyButton()
        setupMessageLabel()
        
    }
    
    func validationForm() {
        
        _ = emailTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.email)
        _ = passwordTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.password)
        
        _ = loginViewModel.isValid.bind(to: enterButton.rx.isEnabled)
        
        // change status
        
        emailTextField.addTarget(self, action: #selector(handleEmailChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handlePasswordChange), for: .editingChanged)

    }
    
    @objc func handleEmailChange() {
        
        _ = loginViewModel.email.asObservable().subscribe({ _ in
            
            self.emailTextField.textColor = self.loginViewModel.validateEmail() ? .black : .red
            ///
            self.emailTextField.messageLabel.text = self.loginViewModel.choiceEmailMessageLabel()
            self.emailTextField.messageLabel.textColor = .red
            
            UIView.animate(withDuration: 0.3, animations: {
                self.emailTextField.messageLabel.isHidden = false
            })
            
            print("email: \(self.loginViewModel.validateEmail())")
        })
    }
    
    @objc func handlePasswordChange() {
        
        _ = loginViewModel.password.asObservable().subscribe({ _ in
            
            self.passwordTextField.textColor = self.loginViewModel.validatePassword() ? .black : .red
            
            self.passwordTextField.messageLabel.text = self.loginViewModel.choicePasswordMessageLabel()
            self.emailTextField.messageLabel.textColor = .red
            
            UIView.animate(withDuration: 0.3, animations: {
                self.passwordTextField.messageLabel.isHidden = false
            })
            
            print("password: \(self.loginViewModel.validatePassword())")
        })
    }
    
    // MARK - setup view
    
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
    
    func setupEnterButton() {
        enterButton.setTitle("Войти", for: .normal)
        enterButton.layer.cornerRadius = 22
        enterButton.setTitleColor(UIColor.rgb(red: 255, green: 255, blue: 255), for: .normal)
        enterButton.backgroundColor = UIColor.rgb(red: 255, green: 155, blue: 0)
    }
    
    func setupEmptyButton() {
        emptyButton.setTitle("У мня еще нет аккаунта. Создать.", for: .normal)
        emptyButton.tintColor = UIColor.rgb(red: 56, green: 133, blue: 199)
        emptyButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func setupMessageLabel() {
        emailTextField.messageLabel.isHidden = true
        passwordTextField.messageLabel.isHidden = true
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
    
    @IBAction func tapEnterButton(_ sender: UIButton) {
        
        // request data using

        _ = loginViewModel.fatchAllWeather().asObservable().subscribe(onNext: { weather in
            
            let weatherPosts = weather[0]
            
            let title = "Погода в городе \(weatherPosts.name)"
            let message = "Температура: " + String(format: "%.1f", weatherPosts.temp) + "C'" + "\nВлажность: " + "\(weatherPosts.humidity)" + "%" + "\nАтмосферное давление: " + "\(weatherPosts.pressure)" + "мм рт. ст."
            
            AlertVC.sharedInstace.createAlert(view: self, title: title, message: message)
            
        })
    }
}
