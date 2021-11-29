//
//  DataModel.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/04.
//

import Foundation
import UIKit

struct Feed: Codable {
    var id: String
    var title: String
    var content: String
    var date: String
    var imageType: String
    var thumbnail: Data?
    var comments: [Comment]
}

struct Comment: Codable {
    var id: String
    var content: String
    var pw: String
    var writer: String
    var date: String
}

struct BlogInfo: Codable {
    var title: String
    var intro: String
    var imageType: String
    var thumbnail: Data?
}

struct HitInfo: Codable {
    var postId: String
    var hitNum: Int
}

