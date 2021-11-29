//
//  FeedListingCell.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/01.
//

import Foundation
import UIKit

class FeedListingCell: UITableViewCell {
    // MARK: - Properties
    let separatorView = UIView()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let thumbnailImageView = UIImageView()
    let commentImageView = UIImageView()
    let commentNumLabel = UILabel()
    
    // MARK: - Default UI Setting
    func style() {
        self.selectionStyle = .gray
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.systemGray5
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.Head2
        titleLabel.numberOfLines = 1
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 2
        contentLabel.font = UIFont.Body2
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.backgroundColor = UIColor.lightGray
        thumbnailImageView.layer.cornerRadius = 10
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.Body3
        dateLabel.textColor = UIColor.darkGray
        
        commentImageView.translatesAutoresizingMaskIntoConstraints = false
        commentImageView.contentMode = .scaleAspectFit
        commentImageView.image = UIImage(systemName: "ellipsis.bubble")?.withHorizontallyFlippedOrientation()
        commentImageView.tintColor = UIColor.darkGray
        
        commentNumLabel.translatesAutoresizingMaskIntoConstraints = false
        commentNumLabel.text = "0"
        commentNumLabel.font = UIFont.Body3
        commentNumLabel.textColor = UIColor.darkGray
    }
    
    func layout() {
        self.addSubview(separatorView)
        self.addSubview(titleLabel)
        self.addSubview(contentLabel)
        self.addSubview(thumbnailImageView)
        self.addSubview(dateLabel)
        self.addSubview(commentImageView)
        self.addSubview(commentNumLabel)

        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -125),
            titleLabel.heightAnchor.constraint(equalToConstant: 23),
            
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -125),
            contentLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
            
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35),
            
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentLabel.leadingAnchor),
            
            commentImageView.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor),
            commentImageView.widthAnchor.constraint(equalToConstant: 15),
            commentImageView.heightAnchor.constraint(equalToConstant: 15),
            
            commentNumLabel.centerYAnchor.constraint(equalTo: self.commentImageView.centerYAnchor),
            commentNumLabel.leadingAnchor.constraint(equalTo: self.commentImageView.trailingAnchor, constant: 2),
            commentNumLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -140),
        ])
    }
    
    // MARK: - Custom UI Setting
    func updateUI(_ info: Feed) {
        thumbnailImageView.image = nil
        titleLabel.text = info.title
        contentLabel.text = info.content
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let dateInfo = dateFormatter.date(from: info.date)!
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateLabel.text = dateFormatter.string(from: dateInfo)
        commentNumLabel.text = "\(info.comments.count)"
        
        if info.imageType != "0" && info.imageType != "No" {
            thumbnailImageView.image = UIImage(named: "image\(info.imageType)")
            return
        }
        guard let imgData = info.thumbnail else {
            thumbnailImageView.image = UIImage(named: "noImage_square")
            return
        }
        thumbnailImageView.image = UIImage(data: imgData)
    }
}
