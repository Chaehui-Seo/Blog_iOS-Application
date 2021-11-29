//
//  RankCell.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/04.
//

import Foundation
import UIKit

class RankCell: UITableViewCell {
    // MARK: - Properties
    let percentageLabel = UILabel()
    let titleLabel = UILabel()
    
    // MARK: - Default UI Setting
    func style() {
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.font = UIFont.Body2
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.Body2
    }
    
    func layout() {
        self.addSubview(percentageLabel)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            percentageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            percentageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 75),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Custom UI Setting
    func updateUI(percentage: Double, feed: Feed?) {
        if let feedInfo = feed {
            let percentageNum = String(format: "%.1f", (percentage * 100))
            percentageLabel.text = "\(percentageNum)%"
            titleLabel.text = "\(feedInfo.title)"
        }
    }
}
