//
//  FeedViewModel.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/01.
//

import Foundation
import UIKit

class FeedViewModel {
    
    static var shared = FeedViewModel()
    
    @Published var feedInfo: [Feed] = []
    
    @Published var hitInfo: [HitInfo] = []
    
    @Published var selectedFeedInfo: Feed?
    
    var hitLastUpdatedDate: String = ""
    var commentLastUpdatedDate: String = ""
    
    func updateSpecificPost(_ info: Feed) {
        FeedViewModel.shared.selectedFeedInfo = info
        if let firstIndex = FeedViewModel.shared.feedInfo.firstIndex(where: { $0.id == info.id }) {
            FeedViewModel.shared.feedInfo[firstIndex] = info
        }
    }
    
    func findPostWithId(_ postId: String) -> Feed? {
        if let info = FeedViewModel.shared.feedInfo.first(where: { $0.id == postId }) {
            return info
        } else {
            return nil
        }
    }
}
