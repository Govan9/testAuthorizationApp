//
//  CustomStackView.swift
//  Authorization
//
//  Created by Admin on 02.11.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

@IBDesignable

class CutomStackView: UIStackView {
    
    func setup() {
        
        // create underline
        let border = CALayer()
        let width = CGFloat(1.0)
        
        border.borderColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        border.frame = CGRect(x: 0, y: self.frame.height, width:  self.frame.width, height: 1)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
