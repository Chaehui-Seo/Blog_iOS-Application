//
//  PhotoSelectDelegate.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/02.
//

import Foundation
import UIKit

protocol PhotoSelectDelegate {
    func photoSelected(_ info: UIImage, _ num: Int)
}
