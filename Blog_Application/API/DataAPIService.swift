//
//  DataAPIService.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/01.
//

import Foundation
import Firebase
import FirebaseStorage

struct DataAPIService {
    static let shared = DataAPIService()
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    // MARK: - Feed(Post)
    // 피드(Post) 관련
    func fetchFeed(completion: @escaping (Int)->Void) {
        ref.child("BlogInfo").child("Feed").observeSingleEvent(of: .value) { (snapshot) in
            var feedList: [Feed] = []
            for child in snapshot.children {
                guard let snap  = child as? DataSnapshot else { return }
                let value = snap.value as? NSDictionary
                let title = value?["title"] as? String ?? "No title"
                let content = value?["content"] as? String ?? "No content"
                let dateInfo = value?["date"] as? String ?? "No date info"
                let imageType = value?["imageType"] as? String ?? "No"
                var commentList: [Comment] = []
                if let comment = value?["comments"] as? [String: [String:Any]] {
                    for (key, value) in comment {
                        let newComment = Comment(id: key, content: value["content"] as? String ?? "댓글이 삭제되었습니다", pw: value["pw"] as? String ?? "", writer: value["writer"] as? String ?? "알 수 없음", date: value["date"] as? String ?? "알 수 없음")
                        commentList.append(newComment)
                    }
                }
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
                commentList.sort{
                    dateFormatter.date(from: $0.date) ?? Date() < dateFormatter.date(from: $1.date) ?? Date()
                }
                let feedInfo = Feed(id: snap.key, title: title, content: content, date: dateInfo, imageType: imageType, comments: commentList)
                feedList.append(feedInfo)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
            feedList.sort {
                dateFormatter.date(from: $0.date) ?? Date() > dateFormatter.date(from: $1.date) ?? Date()
            }
            FeedViewModel.shared.feedInfo = feedList
            
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            let dateString = dateFormatter.string(from: Date())
            FeedViewModel.shared.commentLastUpdatedDate = dateString
            
            if let selected = FeedViewModel.shared.selectedFeedInfo {
                if let updated = FeedViewModel.shared.feedInfo.first(where: { $0.id == selected.id }) {
                    FeedViewModel.shared.selectedFeedInfo = updated
                } else {
                    FeedViewModel.shared.selectedFeedInfo = nil
                }
            }
            for i in FeedViewModel.shared.feedInfo {
                if i.imageType == "0" {
                    storage.reference().child(i.id).getData(maxSize: 10000000) { data, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if let imageData = data {
                            if let index = FeedViewModel.shared.feedInfo.firstIndex(where: { $0.id == i.id }) {
                                FeedViewModel.shared.feedInfo[index].thumbnail = imageData
                                if let selected = FeedViewModel.shared.selectedFeedInfo, FeedViewModel.shared.feedInfo[index].id == selected.id {
                                    FeedViewModel.shared.selectedFeedInfo = Feed(id: selected.id, title: selected.title, content: selected.content, date: selected.date, imageType: selected.imageType, thumbnail: imageData, comments: selected.comments)
                                }
                            }
                        }
                    }
                }
            }
            completion(1)
        }
    }
    
    func fetchSpecificPost(_ postId: String, completion: @escaping (Int)->Void) {
        ref.child("BlogInfo").child("Feed").child(postId).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let title = value?["title"] as? String ?? "No title"
            let content = value?["content"] as? String ?? "No content"
            let dateInfo = value?["date"] as? String ?? "No date info"
            let imageType = value?["imageType"] as? String ?? "No"
            var commentList: [Comment] = []
            if let comment = value?["comments"] as? [String: [String:Any]] {
                for (key, value) in comment {
                    let newComment = Comment(id: key, content: value["content"] as? String ?? "댓글이 삭제되었습니다", pw: value["pw"] as? String ?? "", writer: value["writer"] as? String ?? "알 수 없음", date: value["date"] as? String ?? "알 수 없음")
                    commentList.append(newComment)
                }
            }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
            commentList.sort{
                dateFormatter.date(from: $0.date) ?? Date() < dateFormatter.date(from: $1.date) ?? Date()
            }
            let feedInfo = Feed(id: snapshot.key, title: title, content: content, date: dateInfo, imageType: imageType, comments: commentList)
            FeedViewModel.shared.updateSpecificPost(feedInfo)
            completion(1)
        }
    }
    
    func updateSpecificPost(_ postId: String, _ title: String, _ content: String, _ previousImageType: String, _ imageType: String, _ imageData: UIImage?, completion: @escaping (Int)->Void) {
        self.ref.child("BlogInfo").child("Feed").child(postId).child("title").setValue(title)
        self.ref.child("BlogInfo").child("Feed").child(postId).child("content").setValue(content)
        self.ref.child("BlogInfo").child("Feed").child(postId).child("imageType").setValue(imageType)
        if imageType == "0" {
            if let data = imageData {
                uploadImage(fileName: postId, img: data) { result in
                    completion(result)
                }
            } else {
                completion(1)
            }
        } else {
            if previousImageType == "0" {
                storage.reference().child(postId).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(0)
                    }
                }
            }
            completion(1)
        }
    }
    
    func addNewPost(_ title: String, _ content: String, _ imageType: String, _ imageData: UIImage?, completion: @escaping (Int) -> Void) {
        guard let key = ref.child("BlogInfo").child("Feed").childByAutoId().key else {
            completion(0)
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let dateInfo = dateFormatter.string(from: Date())
        self.ref.child("BlogInfo").child("Feed").child(key).setValue(["title": title, "content": content, "imageType" : imageType, "date": dateInfo])
        if let data = imageData {
            uploadImage(fileName: key, img: data) { result in
                completion(result)
            }
        } else {
            completion(1)
        }
    }
    
    func removeSpecificPost(_ postId: String, completion: @escaping (Int) -> Void) {
        self.ref.child("BlogInfo").child("Feed").child(postId).removeValue()
        self.ref.child("BlogInfo").child("FeedHit").child(postId).removeValue()
        storage.reference().child(postId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        fetchFeed { _ in
            completion(1)
        }
    }
    
    // MARK: - Comment (inside post)
    // 특정 Post의 댓글 관련
    func addCommentInPost(_ postId: String, _ writer: String, _ content: String, _ pw: String, completion: @escaping (Int)->Void) {
        guard let key = ref.child("BlogInfo").child("Feed").child(postId).child("comments").childByAutoId().key else {
            completion(0)
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let dateInfo = dateFormatter.string(from: Date())
        
        self.ref.child("BlogInfo").child("Feed").child(postId).child("comments").child(key).setValue(["content": content, "date": dateInfo, "pw": pw, "writer": writer])
        completion(1)
    }
    
    func updateCommentInPost(_ postId: String, _ commentId: String, _ writer: String, _ content: String, _ pw: String, _ dateInfo: String, completion: @escaping (Int)->Void) {
        ref.child("BlogInfo").child("Feed").child(postId).child("comments").child(commentId).setValue(["content": content, "date": dateInfo, "pw": pw, "writer": writer])
        completion(1)
    }
    
    func removeCommentInPost(_ postId: String, _ commentId: String, completion: @escaping (Int)->Void) {
        ref.child("BlogInfo").child("Feed").child(postId).child("comments").child(commentId).removeValue()
        completion(1)
    }
    
    // MARK: - Blog Info
    // 블로그 정보 관련
    func fetchBlogInfo(completon: @escaping ()->Void) {
        var title = ""
        var intro = ""
        var imageType = ""
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            ref.child("BlogInfo").child("title").observeSingleEvent(of: .value) { (snapshot) in
                title = snapshot.value as? String ?? "블로그 이름을 입력해주세요"
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            ref.child("BlogInfo").child("intro").observeSingleEvent(of: .value) { (snapshot) in
                intro = snapshot.value as? String ?? "블로그 설명을 입력해주세요"
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            ref.child("BlogInfo").child("imageType").observeSingleEvent(of: .value) { (snapshot) in
                imageType = snapshot.value as? String ?? "No"
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.global()) {
            BlogInfoViewModel.shared.blogInfo = BlogInfo(title: title, intro: intro, imageType: imageType)
            if imageType == "0" {
                storage.reference().child("thumbnail").getData(maxSize: 10000000) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let imageData = data else { return }
                    BlogInfoViewModel.shared.blogInfo.thumbnail = imageData
                }
            }
            completon()
        }
    }
    
    func changeBlogTitle(_ title: String, completion: @escaping ()->Void) {
        self.ref.child("BlogInfo").child("title").setValue(title)
        completion()
    }
    
    func changeBlogIntro(_ intro: String, completion: @escaping ()->Void) {
        self.ref.child("BlogInfo").child("intro").setValue(intro)
        completion()
    }
    
    func changeBlogImageType(_ previousImageType: String, _ imageType: String, completion: @escaping ()->Void) {
        if imageType != "0" && previousImageType == "0" {
            storage.reference().child("thumbnail").delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                self.ref.child("BlogInfo").child("imageType").setValue(imageType)
                completion()
            }
        } else {
            self.ref.child("BlogInfo").child("imageType").setValue(imageType)
            completion()
        }
    }
    
    // MARK: - Post Hits
    // 조회수 관련
    func fetchPostHits(completion: @escaping (Int)->Void) {
        var hitInfo: [HitInfo] = []
        ref.child("BlogInfo").child("FeedHit").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                guard let snap  = child as? DataSnapshot else { return }
                let hit = snap.value as? Int ?? 0
                let current = HitInfo(postId: snap.key, hitNum: hit)
                hitInfo.append(current)
            }
            FeedViewModel.shared.hitInfo = hitInfo
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            let dateString = dateFormatter.string(from: Date())
            FeedViewModel.shared.hitLastUpdatedDate = dateString
            completion(1)
        }
    }
    
    func addPostHit(_ postId: String) {
        self.ref.child("BlogInfo").child("FeedHit").child(postId).getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            let temp = snapshot.value as? Int ?? 0
            self.ref.child("BlogInfo").child("FeedHit").child(postId).setValue(temp + 1)
        })
        fetchPostHits { _ in
        }
    }
    
    // MARK: - Firebase Storage
    // Firebase Storage에 이미지 업로드
    func uploadImage(fileName: String, img: UIImage, completion: @escaping (Int)->Void ) {
        var data = Data()
        data = img.jpegData(compressionQuality: 0.5)!
        let filePath = fileName
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storage.reference().child(filePath).putData(data, metadata: metaData) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(0)
                return
            } else {
                print("성공")
                DataAPIService.shared.fetchBlogInfo {
                    completion(1)
                }
            }
        }
    }
}
