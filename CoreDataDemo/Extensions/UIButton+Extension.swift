//
//  UIButton+Extension.swift
//  CoreDataDemo
//
//  Created by vtsyganov on 06.07.2021.
//

import UIKit

extension UIButton {
    /* Custom button's setting class */
    class func customSetting(buttonColor: UIColor, title: String, font: UIFont, titleColor: UIColor, radius: CGFloat, target: Any, action: Selector ) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = buttonColor
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        
        button.layer.cornerRadius = radius
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return button
    }
}
