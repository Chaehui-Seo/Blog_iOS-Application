//
//  ImageCell.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/02.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    // MARK: - Property
    let imageView = UIImageView()
    
    // MARK: - Default UI Setting
    func style() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func layout() {
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Custom UI Setting
    func updateUI(_ imgData: UIImage?) {
        guard let data = imgData else { return }
        imageView.image = data
    }
}
