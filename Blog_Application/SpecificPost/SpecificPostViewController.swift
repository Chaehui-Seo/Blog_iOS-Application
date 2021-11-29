//
//  SpecificPostViewController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/01.
//

import Foundation
import UIKit
import Combine

class SpecificPostViewController: UIViewController {
    // MARK: - Properties
    // 최상단에 위치한 UI
    let backButton = UIButton()
    let blogTitleLabel = UILabel()
    let topSeparatorView = UIView()
    
    let scrollView = UIScrollView()
    let innerView = UIView()
    
    // 게시글 상단 버튼
    let deleteButton = UIButton()
    let editButton = UIButton()
    
    // 썸네일 사진 및 정보 관련 뷰
    let thumbnailImageView = UIImageView()
    let grayView = UIView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    let contentLabel = UITextView()

    let commentButton = UIButton()
    
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        setAction()
        bindViewModel()
    }
    
    // MARK: - UI Setting
    func style() {
        guard let info = FeedViewModel.shared.selectedFeedInfo else { return }
        DataAPIService.shared.addPostHit(info.id)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.tintColor = UIColor.black
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        blogTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        blogTitleLabel.font = UIFont.Head3
        blogTitleLabel.text = BlogInfoViewModel.shared.blogInfo.title
        
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.backgroundColor = UIColor.lightGray
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.tintColor = UIColor.white
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        if #available(iOS 15.0, *) {
            deleteButton.configuration = .plain()
        }
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.tintColor = UIColor.white
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        if #available(iOS 15.0, *) {
            editButton.configuration = .plain()
        }
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.backgroundColor = UIColor.lightGray
        
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.backgroundColor = UIColor(red: 0.154, green: 0.154, blue: 0.154, alpha: 1).withAlphaComponent(0.5)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.font = UIFont.Head3
        titleLabel.text = info.title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.white
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.Body3
        dateLabel.textColor = UIColor.white
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = UIFont.Body2
        contentLabel.text = info.content
        contentLabel.isScrollEnabled = false
        contentLabel.isEditable = false
        
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.backgroundColor = UIColor.lightGray
        commentButton.setImage(UIImage(systemName: "ellipsis.bubble"), for: .normal)
        commentButton.tintColor = UIColor.white
        commentButton.setTitle("댓글", for: .normal)
        commentButton.layer.cornerRadius = 20
    }
    
    func layout() {
        self.view.addSubview(backButton)
        self.view.addSubview(blogTitleLabel)
        self.view.addSubview(scrollView)
        self.view.addSubview(topSeparatorView)
        self.scrollView.addSubview(innerView)
        self.scrollView.addSubview(thumbnailImageView)
        self.scrollView.addSubview(grayView)
        self.scrollView.addSubview(deleteButton)
        self.scrollView.addSubview(editButton)
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(dateLabel)
        self.scrollView.addSubview(contentLabel)
        self.view.addSubview(commentButton)
        
        NSLayoutConstraint.activate([
            
            blogTitleLabel.heightAnchor.constraint(equalToConstant: 21),
            blogTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60),
            blogTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            blogTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            backButton.centerYAnchor.constraint(equalTo: self.blogTitleLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 41),
            backButton.widthAnchor.constraint(equalToConstant: 41),
            
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            topSeparatorView.bottomAnchor.constraint(equalTo: self.scrollView.topAnchor),
            topSeparatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topSeparatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 59),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            innerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            innerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            innerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            innerView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            
            editButton.topAnchor.constraint(equalTo: self.innerView.topAnchor, constant: 15),
            editButton.trailingAnchor.constraint(equalTo: self.innerView.trailingAnchor, constant: -15),
            editButton.heightAnchor.constraint(equalToConstant: 41),
            editButton.widthAnchor.constraint(equalToConstant: 41),
            
            deleteButton.centerYAnchor.constraint(equalTo: self.editButton.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: self.editButton.leadingAnchor, constant: -10),
            deleteButton.heightAnchor.constraint(equalToConstant: 41),
            deleteButton.widthAnchor.constraint(equalToConstant: 41),
            
            thumbnailImageView.topAnchor.constraint(equalTo: self.innerView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.innerView.leadingAnchor),
            thumbnailImageView.centerXAnchor.constraint(equalTo: self.innerView.centerXAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 190),
            
            grayView.topAnchor.constraint(equalTo: self.thumbnailImageView.topAnchor),
            grayView.leadingAnchor.constraint(equalTo: self.thumbnailImageView.leadingAnchor),
            grayView.centerXAnchor.constraint(equalTo: self.thumbnailImageView.centerXAnchor),
            grayView.bottomAnchor.constraint(equalTo: self.thumbnailImageView.bottomAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.thumbnailImageView.leadingAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 9),
            dateLabel.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: self.thumbnailImageView.bottomAnchor, constant: 35),
            contentLabel.leadingAnchor.constraint(equalTo: self.innerView.leadingAnchor, constant: 35),
            contentLabel.centerXAnchor.constraint(equalTo: self.innerView.centerXAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: self.innerView.bottomAnchor, constant:  -80),
            
            commentButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            commentButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            commentButton.widthAnchor.constraint(equalToConstant: 80),
            commentButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - Bind data in ViewModel
    private func bindViewModel() {
        FeedViewModel.shared.$selectedFeedInfo.receive(on: RunLoop.main)
            .sink { [weak self] feedInfo in
                guard let info = feedInfo, let self = self else { return }
                self.titleLabel.text = info.title
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
                let dateInfo = dateFormatter.date(from: info.date)!
                dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
                let dateString = dateFormatter.string(from: dateInfo)
                self.dateLabel.text = dateString
                self.contentLabel.text = info.content
                self.thumbnailImageView.contentMode = .scaleAspectFill
                self.thumbnailImageView.clipsToBounds = true
                if info.imageType != "0" && info.imageType != "No" {
                    self.thumbnailImageView.image = UIImage(named: "image\(info.imageType)")
                    return
                }
                if let imageData = info.thumbnail {
                    self.thumbnailImageView.image = UIImage(data: imageData)
                } else {
                    self.thumbnailImageView.image = UIImage(named: "noImage_long")
                }
            }.store(in: &cancellable)
        BlogInfoViewModel.shared.$blogInfo.receive(on: RunLoop.main)
            .sink { [weak self] blogInfo in
                guard let self = self else { return }
                self.blogTitleLabel.text = blogInfo.title
            }.store(in: &cancellable)
    }
    
    // MARK: - Button Action
    func setAction() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonClicked), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    @objc private func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func commentButtonClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let commentVC = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController else { return }
        self.present(commentVC, animated: true, completion: nil)
    }
    
    @objc private func editButtonClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let writeVC = storyboard.instantiateViewController(withIdentifier: "PostWriteViewController") as? PostWriteViewController else { return }
        writeVC.modalPresentationStyle = .fullScreen
        self.present(writeVC, animated: true, completion: nil)
    }
    
    @objc private func deleteButtonClicked() {
        guard let info = FeedViewModel.shared.selectedFeedInfo else { return }
        let alert = UIAlertController(title: "", message: "게시글을 삭제하시겠습니까?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "삭제", style: .destructive) { _ in
            DataAPIService.shared.removeSpecificPost(info.id) { result in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        let action2 = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
}
