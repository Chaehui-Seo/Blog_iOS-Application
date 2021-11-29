//
//  MainNavigationController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/01.
//

import Foundation
import UIKit

class MainNavigationController : UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}
