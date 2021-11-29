//
//  BlogInfoEditViewController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/02.
//

import Foundation
import UIKit
import Combine

class BlogInfoEditViewController: UIViewController {
    // MARK: - Properties
    // 상단 대문 사진 관련 뷰
    let imageView = UIImageView()
    let grayView = UIView()
    
    // 싱딘 대문 사진 이미지 추가 시 사용되는 버튼 및 picker
    let photoButton = UIButton()
    let imagePickerView = UIImagePickerController()
    
    // 대문 사진 관련 정보
    var isDefaultImage = false
    var defaultImageNum: Int?
    
    // 블로그 이름 관련 UI
    let blogTitleLabel = UILabel()
    let titleTextField = UITextField()
    let titleCountLabel = UILabel()
    let separatorView = UIView()
    
    // 소개 관련 UI
    let blogIntroLabel = UILabel()
    let introTextField = UITextField()
    let introCountLabel = UILabel()
    let separatorView2 = UIView()
    
    // 상단 버튼
    let backButton = UIButton()
    let doneButton = UIButton()
    
    // 로딩 스피너
    var vSpinner: UIView?
    
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.sourceType = .photoLibrary
        imagePickerView.delegate = self
        titleTextField.delegate = self
        introTextField.delegate = self
        style()
        layout()
        bindViewModel()
        setAction()
    }
    
    // MARK: - UI Setting
    func style() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.darkGray
        
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.backgroundColor = UIColor(red: 0.154, green: 0.154, blue: 0.154, alpha: 1).withAlphaComponent(0.5)
        
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        photoButton.backgroundColor = UIColor.mainLightOrange
        photoButton.tintColor = UIColor.white
        photoButton.setImage(UIImage(systemName: "camera"), for: .normal)
        photoButton.layer.cornerRadius = 30
        if #available(iOS 15.0, *) {
            photoButton.configuration = .plain()
        }
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("취소", for: .normal)
        backButton.titleLabel?.font = UIFont.Head3
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("완료", for: .normal)
        doneButton.titleLabel?.font = UIFont.Head3
        
        blogTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        blogTitleLabel.text = "블로그 이름"
        blogTitleLabel.font = UIFont.Head4
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "블로그 이름을 입력해주세요"
        titleTextField.font = UIFont.Head2
        titleTextField.autocorrectionType = .no
        titleTextField.autocapitalizationType = .none
        titleTextField.smartDashesType = .no
        titleTextField.spellCheckingType = .no
        
        titleCountLabel.translatesAutoresizingMaskIntoConstraints = false
        titleCountLabel.text = "0/25"
        titleCountLabel.textColor = UIColor.lightGray
        titleCountLabel.font = UIFont.Body3
        titleCountLabel.textAlignment = .right
        
        blogIntroLabel.translatesAutoresizingMaskIntoConstraints = false
        blogIntroLabel.text = "소개"
        blogIntroLabel.font = UIFont.Head4
        
        introTextField.translatesAutoresizingMaskIntoConstraints = false
        introTextField.placeholder = "소개말을 입력해주세요"
        introTextField.font = UIFont.Body1
        introTextField.autocorrectionType = .no
        introTextField.autocapitalizationType = .none
        introTextField.smartDashesType = .no
        introTextField.spellCheckingType = .no
        
        introCountLabel.translatesAutoresizingMaskIntoConstraints = false
        introCountLabel.text = "0/40"
        introCountLabel.textColor = UIColor.lightGray
        introCountLabel.font = UIFont.Body3
        introCountLabel.textAlignment = .right
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.systemGray5
        
        separatorView2.translatesAutoresizingMaskIntoConstraints = false
        separatorView2.backgroundColor = UIColor.systemGray5
        
    }
    
    func layout() {
        self.view.addSubview(imageView)
        self.view.addSubview(grayView)
        self.view.addSubview(photoButton)
        self.view.addSubview(doneButton)
        self.view.addSubview(backButton)
        self.view.addSubview(blogTitleLabel)
        self.view.addSubview(titleTextField)
        self.view.addSubview(titleCountLabel)
        self.view.addSubview(blogIntroLabel)
        self.view.addSubview(introTextField)
        self.view.addSubview(introCountLabel)
        self.view.addSubview(separatorView)
        self.view.addSubview(separatorView2)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            grayView.topAnchor.constraint(equalTo: self.imageView.topAnchor),
            grayView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor),
            grayView.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            grayView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            
            photoButton.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor, constant: 5),
            photoButton.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            photoButton.widthAnchor.constraint(equalToConstant: 60),
            photoButton.heightAnchor.constraint(equalToConstant: 60),
            
            doneButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            doneButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            doneButton.widthAnchor.constraint(equalToConstant: 41),
            doneButton.heightAnchor.constraint(equalToConstant: 41),
            
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.widthAnchor.constraint(equalToConstant: 41),
            backButton.heightAnchor.constraint(equalToConstant: 41),
            
            blogTitleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 40),
            blogTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            titleTextField.topAnchor.constraint(equalTo: self.blogTitleLabel.bottomAnchor, constant: 5),
            titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleTextField.trailingAnchor.constraint(equalTo: self.titleCountLabel.leadingAnchor, constant: 5),
            titleTextField.heightAnchor.constraint(equalToConstant: 35),
            
            titleCountLabel.bottomAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: -5),
            titleCountLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            titleCountLabel.widthAnchor.constraint(equalToConstant: 60),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            separatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor),
            
            blogIntroLabel.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor, constant: 40),
            blogIntroLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            introTextField.topAnchor.constraint(equalTo: self.blogIntroLabel.bottomAnchor, constant: 5),
            introTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            introTextField.trailingAnchor.constraint(equalTo: self.introCountLabel.leadingAnchor, constant: 5),
            introTextField.heightAnchor.constraint(equalToConstant: 35),
            
            introCountLabel.bottomAnchor.constraint(equalTo: self.introTextField.bottomAnchor, constant: -5),
            introCountLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            introCountLabel.widthAnchor.constraint(equalToConstant: 60),
            
            separatorView2.heightAnchor.constraint(equalToConstant: 1),
            separatorView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            separatorView2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            separatorView2.topAnchor.constraint(equalTo: self.introTextField.bottomAnchor),
        ])
    }
    
    // MARK: - Bind data in ViewModel
    private func bindViewModel() {
        BlogInfoViewModel.shared.$blogInfo.receive(on: RunLoop.main)
            .sink { [weak self] blogInfo in
                guard let self = self else { return }
                self.titleTextField.text = blogInfo.title
                self.titleCountLabel.text = "\(blogInfo.title.count)/25"
                self.introTextField.text = blogInfo.intro
                self.introCountLabel.text = "\(blogInfo.intro.count)/40"
                if blogInfo.imageType != "0" && blogInfo.imageType != "No" {
                    self.defaultImageNum = Int(blogInfo.imageType)
                    self.isDefaultImage = true
                    self.imageView.image = UIImage(named: "image\(blogInfo.imageType)")
                    return
                }
                self.isDefaultImage = false
                if let imageData = BlogInfoViewModel.shared.blogInfo.thumbnail {
                    self.imageView.image = UIImage(data: imageData)
                } else {
                    self.imageView.image = UIImage(named: "noImage_long")
                }
            }.store(in: &cancellable)
    }
    
    // MARK: - Button Action
    func setAction() {
        photoButton.addTarget(self, action: #selector(photoButtonClicked), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    @objc private func photoButtonClicked() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "기본 이미지 선택", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let selectVC = storyboard.instantiateViewController(withIdentifier: "PhotoSelectViewController") as? PhotoSelectViewController else { return }
            selectVC.delegate = self
            self.present(selectVC, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            self.present(self.imagePickerView, animated: true, completion: nil)
        }
        let action3 = UIAlertAction(title: "사진 삭제", style: .default) { _ in
            self.imageView.image = UIImage(named: "noImage_long")
            self.isDefaultImage = false
        }
        let action4 = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func doneButtonClicked() {
        showSpinner(onView: self.view)
        
        guard let titleInfo = self.titleTextField.text, titleInfo.isEmpty == false, let introInfo = self.introTextField.text, introInfo.isEmpty == false else {
            self.removeSpinner()
            let alert = UIAlertController(title: "", message: "이름과 소개말은 필수적으로 입력해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let group = DispatchGroup()
        
        if let imgInfo = self.imageView.image, isDefaultImage == false, imgInfo != UIImage(named: "noImage_long") {
            group.enter()
            DispatchQueue.global().async {
                DataAPIService.shared.uploadImage(fileName: "thumbnail", img: imgInfo) { result in
                    group.leave()
                }
            }
        }
        
        if titleInfo != BlogInfoViewModel.shared.blogInfo.title {
            group.enter()
            DispatchQueue.global().async {
                DataAPIService.shared.changeBlogTitle(titleInfo) {
                    group.leave()
                }
            }
        }
        
        if introInfo != BlogInfoViewModel.shared.blogInfo.intro {
            group.enter()
            DispatchQueue.global().async {
                DataAPIService.shared.changeBlogIntro(introInfo) {
                    group.leave()
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            var imageType = "No"
            DispatchQueue.main.async {
                if self.isDefaultImage == true, let defaultNum = self.defaultImageNum {
                    imageType = "\(defaultNum)"
                } else if let imgData = self.imageView.image, imgData != UIImage(named: "noImage_long") {
                    imageType = "0"
                }
                DataAPIService.shared.changeBlogImageType(BlogInfoViewModel.shared.blogInfo.imageType, imageType) {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.global()) {
            DispatchQueue.global().async {
                DataAPIService.shared.fetchBlogInfo {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc private func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Spinner
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}

extension BlogInfoEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UIImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        self.imageView.image = newImage
        self.isDefaultImage = false
        picker.dismiss(animated: true, completion: nil)
    }
}

extension BlogInfoEditViewController: UITextFieldDelegate {
    // MARK: - UITextField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == titleTextField {
            if textField.text?.count ?? 0 > 25 {
                textField.deleteBackward()
                return
            }
            self.titleCountLabel.text = "\(textField.text?.count ?? 0)/25"
        } else {
            if textField.text?.count ?? 0 > 40 {
                textField.deleteBackward()
                return
            }
            self.introCountLabel.text = "\(textField.text?.count ?? 0)/40"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension BlogInfoEditViewController: PhotoSelectDelegate {
    // MARK: - Custom ImagePick
    func photoSelected(_ info: UIImage, _ num: Int) {
        self.imageView.image = info
        self.defaultImageNum = num
        self.isDefaultImage = true
    }
}
