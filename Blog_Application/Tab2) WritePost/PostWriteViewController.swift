//
//  PostWriteViewController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/01.
//

import Foundation
import UIKit
import Combine

class PostWriteViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    
    // 최상단 UI
    @IBOutlet weak var titleLabel: UILabel!
    let cancelButton = UIButton()
    let doneButton = UIButton()
    
    // 게시글 작성하는 UI
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    let contentPlaceHolderLabel = UILabel()
    
    // 썸네일 사진 추가 관련 UI
    let thumbnailView = UIView()
    let photoAddButton = UIButton()
    let currentPhotoButton = UIButton()
    let defaultImageView = UIImageView()
    let imagePickerView = UIImagePickerController()
    var isDefaultImage = false
    var defaultImageNum : Int?
    
    // 로딩 스피너
    var vSpinner: UIView?
    
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        imagePickerView.delegate = self
        contentTextView.delegate = self
        bindViewModel()
        style()
        layout()
        setAction()
    }
    
    // MARK: - UI Setting
    func style() {
        titleLabel.font = UIFont.Head3
        titleLabel.text = "글작성"

        titleTextField.placeholder = "제목을 입력해주세요"
        titleTextField.font = UIFont.Head3
        titleTextField.autocorrectionType = .no
        titleTextField.autocapitalizationType = .none
        titleTextField.smartDashesType = .no
        titleTextField.spellCheckingType = .no
        
        titleCountLabel.text = "0/35"
        titleCountLabel.textColor = UIColor.lightGray
        titleCountLabel.font = UIFont.Body3
        
        contentTextView.isScrollEnabled = false
        contentTextView.font = UIFont.Body2
        contentTextView.autocorrectionType = .no
        contentTextView.autocapitalizationType = .none
        contentTextView.smartDashesType = .no
        contentTextView.spellCheckingType = .no
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont.Head3
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("등록", for: .normal)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.titleLabel?.font = UIFont.Head3
        
        photoAddButton.translatesAutoresizingMaskIntoConstraints = false
        photoAddButton.backgroundColor = UIColor.mainLightOrange
        photoAddButton.setTitle("사진 선택하기", for: .normal)
        photoAddButton.layer.cornerRadius = 15
        
        currentPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        currentPhotoButton.layer.cornerRadius = 5
        currentPhotoButton.imageView?.contentMode = .scaleAspectFill
        currentPhotoButton.clipsToBounds = true
        currentPhotoButton.imageView?.clipsToBounds = true
        
        defaultImageView.translatesAutoresizingMaskIntoConstraints = false
        defaultImageView.contentMode = .scaleAspectFill
        defaultImageView.clipsToBounds = true
        defaultImageView.image = UIImage(named: "noImage_square")
        defaultImageView.layer.cornerRadius = 5
        
        contentPlaceHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentPlaceHolderLabel.textColor = UIColor.systemGray3
        contentPlaceHolderLabel.font = UIFont.Body2
        contentPlaceHolderLabel.text = "내용을 입력해주세요"
    }
    
    func layout() {
        self.view.addSubview(cancelButton)
        self.view.addSubview(doneButton)
        self.view.addSubview(photoAddButton)
        self.view.addSubview(defaultImageView)
        self.view.addSubview(currentPhotoButton)
        self.view.addSubview(contentPlaceHolderLabel)

        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            doneButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 41),
            doneButton.heightAnchor.constraint(equalToConstant: 41),

            cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            cancelButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 41),
            cancelButton.heightAnchor.constraint(equalToConstant: 41),
            
            photoAddButton.heightAnchor.constraint(equalToConstant: 30),
            photoAddButton.widthAnchor.constraint(equalToConstant: 150),
            photoAddButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            photoAddButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            currentPhotoButton.bottomAnchor.constraint(equalTo: self.photoAddButton.topAnchor, constant: -10),
            currentPhotoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            currentPhotoButton.widthAnchor.constraint(equalToConstant: 65),
            currentPhotoButton.heightAnchor.constraint(equalToConstant: 65),
            
            defaultImageView.topAnchor.constraint(equalTo: self.currentPhotoButton.topAnchor),
            defaultImageView.bottomAnchor.constraint(equalTo: self.currentPhotoButton.bottomAnchor),
            defaultImageView.leadingAnchor.constraint(equalTo: self.currentPhotoButton.leadingAnchor),
            defaultImageView.centerXAnchor.constraint(equalTo: self.currentPhotoButton.centerXAnchor),
            
            contentPlaceHolderLabel.topAnchor.constraint(equalTo: contentTextView.topAnchor, constant: 5),
            contentPlaceHolderLabel.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor, constant: 5)
        ])
    }
    
    // MARK: - Bind data in ViewModel
    private func bindViewModel() {
        FeedViewModel.shared.$selectedFeedInfo.receive(on: RunLoop.main)
            .sink {[weak self] feedInfo in
                guard let self = self else { return }
                guard let info = feedInfo else {
                    self.titleTextField.text = ""
                    self.contentTextView.text = ""
                    self.currentPhotoButton.imageView?.image = nil
                    self.defaultImageView.image = UIImage(named: "noImage_square")
                    return
                }
                self.contentPlaceHolderLabel.isHidden = !info.title.isEmpty
                self.titleTextField.text = info.title
                self.titleCountLabel.text = "\(info.title.count)/35"
                self.titleCountLabel.textColor = UIColor.lightGray
                self.contentTextView.text = info.content
                
                if info.imageType != "0" && info.imageType != "No" {
                    self.defaultImageView.image = UIImage(named: "image\(info.imageType)")
                    self.isDefaultImage = true
                    self.defaultImageNum = Int(info.imageType)
                    return
                }
                self.isDefaultImage = false
                if let imageData = info.thumbnail {
                    self.defaultImageView.image = UIImage(data: imageData)
                }
            }.store(in: &cancellable)
    }

    // MARK: - Button Action
    func setAction() {
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        photoAddButton.addTarget(self, action: #selector(photoAddButtonClicked), for: .touchUpInside)
    }
    
    @objc private func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonClicked() {
        guard let titleInfo = titleTextField.text, titleInfo.isEmpty == false, let contentInfo = contentTextView.text, contentInfo.isEmpty == false else {
            let alert = UIAlertController(title: "", message: "모든 내용을 입력해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        showSpinner(onView: self.view)
        if let info = FeedViewModel.shared.selectedFeedInfo {
            var imageType = "No"
            if let newImage = currentPhotoButton.imageView?.image {
                if isDefaultImage == true, let defaultNum = defaultImageNum {
                    imageType = "\(defaultNum)"
                } else if newImage != UIImage(named: "noImage_square") {
                    imageType = "0"
                }
            } else {
                imageType = info.imageType
            }
            if isDefaultImage == true, let defaultNum = defaultImageNum {
                imageType = "\(defaultNum)"
            } else if let imageInfo = currentPhotoButton.imageView?.image, imageInfo != UIImage(named: "noImage_square") {
                imageType = "0"
            }
            DataAPIService.shared.updateSpecificPost(info.id, titleInfo, contentInfo, info.imageType, imageType, (isDefaultImage == true || currentPhotoButton.imageView?.image == UIImage(named: "noImage_square")) ? nil : currentPhotoButton.imageView?.image) { result in
                DataAPIService.shared.fetchFeed { result in
                    if result == 1 {
                        DispatchQueue.main.async {
                            self.removeSpinner()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            var imageType = "No"
            if isDefaultImage == true, let defaultNum = defaultImageNum {
                imageType = "\(defaultNum)"
            } else if let imageInfo = currentPhotoButton.imageView?.image, imageInfo != UIImage(named: "noImage_square") {
                imageType = "0"
            }
            DataAPIService.shared.addNewPost(titleInfo, contentInfo, imageType, (isDefaultImage == true || currentPhotoButton.imageView?.image == UIImage(named: "noImage_square")) ? nil : currentPhotoButton.imageView?.image) { result in
                if result == 0 {
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        let alert = UIAlertController(title: "", message: "모든 오류가 발생했습니다. 잠시 후 다시 시도해주세요", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    DataAPIService.shared.fetchFeed { result in
                        if result == 1 {
                            DispatchQueue.main.async {
                                self.removeSpinner()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func photoAddButtonClicked() {
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
            self.currentPhotoButton.setImage(UIImage(named: "noImage_square"), for: .normal)
            self.isDefaultImage = false
        }
        let action4 = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Tap Gesture
    @IBAction func backGroundTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
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

extension PostWriteViewController {
    // MARK: - Keyboard up/down adjustment
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            scrollViewBottom.constant = (adjustmentHeight)
            self.view.layoutIfNeeded()
        } else {
            scrollViewBottom.constant = 130
            self.view.layoutIfNeeded()
        }
    }
}

extension PostWriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UIImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        self.isDefaultImage = false
        self.currentPhotoButton.setImage(newImage, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PostWriteViewController: PhotoSelectDelegate {
    // MARK: - Custom imagePicker
    func photoSelected(_ info: UIImage, _ num: Int) {
        self.isDefaultImage = true
        self.defaultImageNum = num
        self.currentPhotoButton.setImage(info, for: .normal)
    }
}

extension PostWriteViewController: UITextFieldDelegate {
    // MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func titleTextFieldEditingChanged(_ sender: Any) {
        if titleTextField.text?.count ?? 0 > 35 {
            titleTextField.deleteBackward()
            return
        }
        self.titleCountLabel.text = "\(titleTextField.text?.count ?? 0)/35"
    }
}

extension PostWriteViewController: UITextViewDelegate {
    // MARK: - UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentPlaceHolderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text, text.isEmpty == false {
            contentPlaceHolderLabel.isHidden = true
        } else {
            contentPlaceHolderLabel.isHidden = false
        }
    }
}
