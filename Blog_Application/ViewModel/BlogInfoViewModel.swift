//
//  BlogInfoViewModel.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/04.
//

import Foundation
import UIKit
import Combine

class BlogInfoViewModel {
    static var shared = BlogInfoViewModel()
    
    @Published var blogInfo = BlogInfo(title: "", intro: "", imageType: "No")
}
