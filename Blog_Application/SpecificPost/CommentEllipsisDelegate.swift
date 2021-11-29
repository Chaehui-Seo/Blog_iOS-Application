//
//  CommentEllipsisDelegate.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/04.
//

import Foundation
import UIKit

protocol CommentEllipsisDeleagte: AnyObject {
    func ellipseButtonClicked(_ info: Comment)
}
