//
//  CommentCell.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/04.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
    // MARK: - Properties
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let contentLabel = UILabel()
    let ellipseButton = UIButton()
    var cellDelegate: CommentEllipsisDeleagte?
    var commentInfo: Comment?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.ellipseButton.addTarget(self, action: #selector(ellipseClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Default UI Setting
    func style() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.Head4
        nameLabel.numberOfLines = 0
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.Body3
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = UIFont.Body2
        contentLabel.numberOfLines = 0
        
        ellipseButton.translatesAutoresizingMaskIntoConstraints = false
        ellipseButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        ellipseButton.tintColor = UIColor.darkGray
    }
    
    func layout() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(ellipseButton)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: self.dateLabel.leadingAnchor, constant: -10),
            
            dateLabel.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -45),
            dateLabel.widthAnchor.constraint(equalToConstant: 100),
            
            contentLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25),
            contentLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            ellipseButton.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor),
            ellipseButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -25),
            ellipseButton.widthAnchor.constraint(equalToConstant: 35),
            ellipseButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Custom UI Setting
    func updateUI(_ info: Comment) {
        commentInfo = info
        nameLabel.text = info.writer
        contentLabel.text = info.content
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let dateInfo = dateFormatter.date(from: info.date)!
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateLabel.text = dateFormatter.string(from: dateInfo)
    }
    
    // MARK: - Button Action
    @objc func ellipseClicked() {
        guard let info = commentInfo else { return }
        self.backgroundColor = UIColor.systemGray6
        cellDelegate?.ellipseButtonClicked(info)
    }
}
