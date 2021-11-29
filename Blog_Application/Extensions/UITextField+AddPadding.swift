//
//  UITextField+AddLeftPadding.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/03.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
