//
//  FeedSquareCell.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/04.
//

import Foundation
import UIKit

class FeedSquareCell: UICollectionViewCell {
    // MARK: - Properties
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let grayView = UIView()
    
    // MARK: - Default UI Setting
    func style() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.Head3
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.lightGray
        
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.backgroundColor = UIColor(red: 0.154, green: 0.154, blue: 0.154, alpha: 1).withAlphaComponent(0.5)
    }
    
    func layout() {
        self.addSubview(imageView)
        self.addSubview(grayView)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            grayView.topAnchor.constraint(equalTo: self.topAnchor),
            grayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            grayView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            grayView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    // MARK: - Custom UI Setting
    func updateUI(_ info: Feed) {
        imageView.image = nil
        titleLabel.text = info.title
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        if info.imageType != "0" && info.imageType != "No" {
            imageView.image = UIImage(named: "image\(info.imageType)")
            return
        }
        guard let imageData = info.thumbnail else {
            imageView.image = UIImage(named: "noImage_square")
            imageView.alpha = 0.7
            return
        }
        imageView.image = UIImage(data: imageData)
    }
}
