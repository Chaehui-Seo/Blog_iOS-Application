//
//  MainPageHeaderView.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/10/30.
//

import Foundation
import UIKit

class MainPageHeaderView: UIView {
    // MARK: - Properties
    let titleLabel = UILabel()
    let centeredTitleLabel = UILabel()
    let introductionLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        style()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
        layout()
    }
    
    // MARK: - Default UI Setting
    func style() {
        self.backgroundColor = UIColor(red: 0.154, green: 0.154, blue: 0.154, alpha: 1).withAlphaComponent(0.5)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.Head1
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byCharWrapping
        
        centeredTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        centeredTitleLabel.font = UIFont.Head3
        centeredTitleLabel.textColor = UIColor.black
        centeredTitleLabel.textAlignment = .center
        centeredTitleLabel.alpha = 0
        
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.textColor = UIColor.white
        introductionLabel.font = UIFont.Body1
        introductionLabel.textAlignment = .center
        introductionLabel.numberOfLines = 0
    }
    
    func layout() {
        addSubview(titleLabel)
        addSubview(introductionLabel)
        addSubview(centeredTitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            introductionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            introductionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            introductionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            centeredTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -83),
            centeredTitleLabel.heightAnchor.constraint(equalToConstant: 21),
            centeredTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65),
            centeredTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Custom UI Setting
    func setUI(_ titleInfo: String, _ introInfo: String) {
        titleLabel.text = titleInfo
        centeredTitleLabel.text = titleInfo
        introductionLabel.text = introInfo
    }
}
