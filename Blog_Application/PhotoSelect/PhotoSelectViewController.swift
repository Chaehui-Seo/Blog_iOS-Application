//
//  PhotoSelectViewController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/02.
//

import Foundation
import UIKit

class PhotoSelectViewController: UIViewController {
    // MARK: - Properties
    
    // 기본 제공 이미지 리스트
    // 해당 이미지는 서버에 저장하지 않고, 앱단에서 바로 보여줌
    let imageData = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4"), UIImage(named: "image5"), UIImage(named: "image6"), UIImage(named: "image7"), UIImage(named: "image8"), UIImage(named: "image9"), UIImage(named: "image10"), UIImage(named: "image11"), UIImage(named: "image12")]
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    let cancelButton = UIButton()
    
    var delegate: PhotoSelectDelegate?
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        style()
        layout()
        setAction()
    }
    
    // MARK: - UI Setting
    func style() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 2
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(UIColor.systemBlue, for: .normal)
        cancelButton.titleLabel?.font = UIFont.Body2
    }
    
    func layout() {
        self.view.addSubview(collectionView)
        self.view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5),
            cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Button Action
    func setAction() {
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }
    
    @objc func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotoSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        cell.style()
        cell.layout()
        cell.updateUI(imageData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = imageData[indexPath.item] else { return }
        delegate?.photoSelected(data, (indexPath.item + 1))
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 4) / 3
        return CGSize(width: width, height: width)
    }
}
