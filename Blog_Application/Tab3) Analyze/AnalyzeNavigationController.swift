//
//  AnalyzeNavigationController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/04.
//

import Foundation
import UIKit

class AnalyzeNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
}
