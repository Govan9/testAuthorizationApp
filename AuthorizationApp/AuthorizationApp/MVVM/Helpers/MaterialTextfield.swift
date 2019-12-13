//
//  MaterialTextfield.swift
//  AuthorizationApp
//
//  Created by Admin on 12.12.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MatetialTextfield: UITextField {
    
    let placeholderLabel = UILabel()
    let underLine = UIView()
    var messageLabel = UILabel()
    let rightButton = UIButton()
    
    private let placeholderSize: CGFloat = 13
    private let textSize: CGFloat = 16
    
    var isActive = false
    
    // placeholder will resize and move
    var placelolderMinimized = false {
        didSet {
            
            guard (oldValue != placelolderMinimized) else { return }
            
            let transform: CGAffineTransform!
            
            if placelolderMinimized {
                let scale = placeholderSize / textSize
                transform = CGAffineTransform(translationX: -5, y: -20).scaledBy(x: scale, y: scale)
            } else {
                transform = .identity
            }
            
            UILabel.animate(withDuration: 0.3, animations: {
                self.placeholderLabel.layer.setAffineTransform(transform)
            })
        }
    }
    
    override var placeholder: String? {
        set {
            placeholderLabel.text = newValue
            placeholderLabel.sizeToFit()
        } get {
            return placeholderLabel.text
        }
    }
    
    var placeholderColor: UIColor! {
        didSet{
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tintColor = textColor
        
        addSubview(placeholderLabel)
        placeholderLabel.font = UIFont.systemFont(ofSize: textSize)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor))
        addConstraint(placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
        
        addSubview(underLine)
        underLine.frame = CGRect(x: 0, y: self.frame.height + 10, width: self.frame.width, height: 1)
        underLine.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
        
        addSubview(messageLabel)
        messageLabel.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 12)
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.text = "message"
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
        addConstraint(messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 15))
        
        addSubview(rightButton)
        
        addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(changedEditing), for: .editingChanged)
        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }
    
    @objc func beginEditing() {
        UIView.animate(withDuration: 0.3, animations: {
            self.underLine.backgroundColor = UIColor.gray
        })
        isActive = true
        updateStatus()
    }
    
    @objc func changedEditing() {
        updateStatus()
    }
    
    @objc func didEndEditing() {
        UIView.animate(withDuration: 0.3, animations: {
            self.underLine.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
        })
        isActive = false
        updateStatus()
    }
    
    func updateStatus() {
        placelolderMinimized = isActive || !text!.isEmpty
    }
    
    func setupRightButton() {
        
        rightButton.frame = CGRect(x: 0, y: 0, width: 113, height: 30)
        rightButton.layer.borderWidth = 1.0
        rightButton.layer.cornerRadius = 4
        rightButton.layer.borderColor = UIColor.rgb(red: 234, green: 234, blue: 234).cgColor
        rightButton.setTitle("Забыли пароль?", for: .normal)
        rightButton.setTitleColor(UIColor.rgb(red: 121, green: 121, blue: 121), for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        rightButton.contentHorizontalAlignment = .center
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-8)-[v(30)]-(8)-|", options: .alignAllBottom, metrics: nil, views: ["v": rightButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v(113)]|", options: .alignAllRight, metrics: nil, views: ["v": rightButton]))
        
    }
}
