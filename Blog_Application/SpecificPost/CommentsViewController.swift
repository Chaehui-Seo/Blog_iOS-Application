//
//  CommentsViewController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/01.
//

import Foundation
import UIKit

class CommentsViewController: UIViewController {
    // MARK: - Properties
    // 최상단 UI
    let commentTitleLabel = UILabel()
    let titleLabel = UILabel()
    let topSeparatorView = UIView()
    
    // 현재 댓글 뷰
    let tableView = UITableView()
    let noCommentLabel = UILabel()
    
    // 댓글 작성 뷰
    let bottomSeparatorView = UIView()
    let commentView = UIView()
    let nickNameTextField = UITextField()
    let nickNameCountLabel = UILabel()
    let pwTextField = UITextField()
    let commentTextView = UITextView()
    let registerButton = UIButton()
    var commentViewBottom: NSLayoutConstraint!
    
    // 수정 및 삭제 시도 시 임시 저장
    var commentInfo: Comment?
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        nickNameTextField.delegate = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        style()
        layout()
        setAction()
    }

    // MARK: - UI Setting
    func style() {
        guard let info = FeedViewModel.shared.selectedFeedInfo else { return }
        commentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        commentTitleLabel.font = UIFont.Body1
        commentTitleLabel.text = "댓글"
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.Head3
        titleLabel.text = info.title
        titleLabel.textAlignment = .center
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        commentView.translatesAutoresizingMaskIntoConstraints = false
        
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.backgroundColor = UIColor.lightGray
        
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView.backgroundColor = UIColor.lightGray
        
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.addLeftPadding()
        nickNameTextField.addRightPadding()
        nickNameTextField.layer.borderColor = UIColor.systemGray5.cgColor
        nickNameTextField.layer.borderWidth = 1
        nickNameTextField.placeholder = "닉네임"
        nickNameTextField.autocorrectionType = .no
        nickNameTextField.autocapitalizationType = .none
        nickNameTextField.smartDashesType = .no
        nickNameTextField.spellCheckingType = .no
        nickNameTextField.returnKeyType = .done
        nickNameTextField.textContentType = .nickname
        nickNameTextField.layer.cornerRadius = 5
        nickNameTextField.font = UIFont.Body2
        
        nickNameCountLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameCountLabel.text = "0/10"
        nickNameCountLabel.textColor = UIColor.lightGray
        nickNameCountLabel.font = UIFont.Body3
        
        pwTextField.translatesAutoresizingMaskIntoConstraints = false
        pwTextField.layer.borderColor = UIColor.systemGray5.cgColor
        pwTextField.layer.borderWidth = 1
        pwTextField.placeholder = "비밀번호 (수정 및 삭제 시 사용)"
        pwTextField.autocorrectionType = .no
        pwTextField.autocapitalizationType = .none
        pwTextField.smartDashesType = .no
        pwTextField.spellCheckingType = .no
        pwTextField.font = UIFont.Body2
        pwTextField.isSecureTextEntry = true
        pwTextField.layer.cornerRadius = 5
        pwTextField.addLeftPadding()
        
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.layer.borderColor = UIColor.systemGray5.cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 5
        commentTextView.autocorrectionType = .no
        commentTextView.autocapitalizationType = .none
        commentTextView.smartDashesType = .no
        commentTextView.spellCheckingType = .no
        commentTextView.font = UIFont.Body2
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.backgroundColor = UIColor.lightGray
        registerButton.layer.cornerRadius = 5
        registerButton.setTitle("등록", for: .normal)
        
        noCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        noCommentLabel.font = UIFont.Body2
        noCommentLabel.textAlignment = .center
        noCommentLabel.text = "첫 번째 댓글을 입력해보세요"
    }
    
    func layout() {
        self.view.addSubview(commentTitleLabel)
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(commentView)
        self.view.addSubview(topSeparatorView)
        self.view.addSubview(bottomSeparatorView)
        self.view.addSubview(nickNameTextField)
        self.view.addSubview(commentTextView)
        self.view.addSubview(pwTextField)
        self.view.addSubview(registerButton)
        self.view.addSubview(noCommentLabel)
        self.view.addSubview(nickNameCountLabel)
        commentViewBottom = commentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            commentTitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 18),
            commentTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: self.commentTitleLabel.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.commentView.topAnchor),
            
            topSeparatorView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 79),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            topSeparatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topSeparatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            bottomSeparatorView.bottomAnchor.constraint(equalTo: self.commentView.topAnchor, constant: 1),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomSeparatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            nickNameTextField.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 12),
            nickNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 33),
            nickNameTextField.trailingAnchor.constraint(equalTo: self.pwTextField.leadingAnchor, constant: -12),
            
            nickNameCountLabel.bottomAnchor.constraint(equalTo: self.nickNameTextField.bottomAnchor, constant: -10),
            nickNameCountLabel.trailingAnchor.constraint(equalTo: self.nickNameTextField.trailingAnchor, constant: -5),
            
            commentView.heightAnchor.constraint(equalToConstant: 130),
            commentViewBottom,
            commentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            commentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            pwTextField.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 12),
            pwTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            pwTextField.heightAnchor.constraint(equalToConstant: 33),
            pwTextField.widthAnchor.constraint(equalToConstant: 200),
            
            commentTextView.topAnchor.constraint(equalTo: self.nickNameTextField.bottomAnchor, constant: 12),
            commentTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            commentTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100),
            commentTextView.bottomAnchor.constraint(equalTo: self.commentView.bottomAnchor, constant: -12),
            
            registerButton.topAnchor.constraint(equalTo: self.nickNameTextField.bottomAnchor, constant: 12),
            registerButton.leadingAnchor.constraint(equalTo: self.commentTextView.trailingAnchor, constant: 12),
            registerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            registerButton.bottomAnchor.constraint(equalTo: self.commentView.bottomAnchor, constant: -12),
            
            noCommentLabel.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 60),
            noCommentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    // MARK: - Button Action
    func setAction() {
        registerButton.addTarget(self, action: #selector(commentRegisterButtonClicked), for: .touchUpInside)
    }
    
    @objc private func commentRegisterButtonClicked() {
        guard let nickname = nickNameTextField.text, nickname.isEmpty == false, let pw = pwTextField.text, pw.isEmpty == false, let content = commentTextView.text, content.isEmpty == false, let info = FeedViewModel.shared.selectedFeedInfo else {
            return
        }
        if let editingComment = commentInfo {
            DataAPIService.shared.updateCommentInPost(info.id, editingComment.id, nickname, content, pw, editingComment.date) { result in
                DispatchQueue.main.async {
                    self.nickNameTextField.resignFirstResponder()
                    self.nickNameTextField.text = ""
                    self.nickNameCountLabel.text = "0/10"
                    self.pwTextField.text = ""
                    self.pwTextField.resignFirstResponder()
                    self.commentTextView.text = ""
                    self.commentTextView.resignFirstResponder()
                }
                DataAPIService.shared.fetchSpecificPost(info.id) { result in
                    if result == 1 {
                        self.style()
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            DataAPIService.shared.addCommentInPost(info.id, nickname, content, pw) { result in
                DispatchQueue.main.async {
                    self.nickNameTextField.text = ""
                    self.nickNameCountLabel.text = "0/10"
                    self.nickNameTextField.resignFirstResponder()
                    self.pwTextField.text = ""
                    self.pwTextField.resignFirstResponder()
                    self.commentTextView.text = ""
                    self.commentTextView.resignFirstResponder()
                }
                DataAPIService.shared.fetchSpecificPost(info.id) { result in
                    if result == 1 {
                        self.style()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        nickNameTextField.resignFirstResponder()
        pwTextField.resignFirstResponder()
        commentTextView.resignFirstResponder()
    }
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let info = FeedViewModel.shared.selectedFeedInfo else {
            noCommentLabel.isHidden = false
            return 0
        }
        if info.comments.count == 0 {
            noCommentLabel.isHidden = false
        } else {
            noCommentLabel.isHidden = true
        }
        return info.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        guard let info = FeedViewModel.shared.selectedFeedInfo else {
            return cell
        }
        cell.cellDelegate = self
        cell.style()
        cell.layout()
        cell.ellipseButton.isEnabled = true
        cell.updateUI(info.comments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CommentsViewController: UITextFieldDelegate {
    // MARK: - UITextField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nickNameTextField {
            if textField.text?.count ?? 0 > 10 {
                textField.deleteBackward()
                return
            }
            self.nickNameCountLabel.text = "\(textField.text?.count ?? 0)/10"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension CommentsViewController: CommentEllipsisDeleagte {
    // MARK: - Custom comment delegate
    func ellipseButtonClicked(_ info: Comment){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "수정하기", style: .default) { _ in
            let alert = UIAlertController(title: nil, message: "비밀번호를 입력해주세요", preferredStyle: .alert)
            alert.addTextField { textfield in
                textfield.isSecureTextEntry = true
                textfield.autocorrectionType = .no
                textfield.autocapitalizationType = .none
                textfield.smartDashesType = .no
                textfield.spellCheckingType = .no
                textfield.font = UIFont.Body2
            }
            let action1 = UIAlertAction(title: "취소", style: .cancel) { _ in
                self.tableView.reloadData()
            }
            let action2 = UIAlertAction(title: "확인", style: .default) { _ in
                if let pwInfo = alert.textFields?[0].text, pwInfo.isEmpty == false, info.pw == pwInfo {
                    self.commentInfo = info
                    self.nickNameTextField.text = info.writer
                    self.nickNameCountLabel.text = "\(info.writer.count)/10"
                    self.pwTextField.text = info.pw
                    self.commentTextView.text = info.content
                    self.commentTextView.becomeFirstResponder()
                } else {
                    let alert = UIAlertController(title: "", message: "비밀번호가 틀렸습니다", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.tableView.reloadData()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            alert.addAction(action1)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "삭제하기", style: .default) { _ in
            let alert = UIAlertController(title: nil, message: "비밀번호를 입력해주세요", preferredStyle: .alert)
            alert.addTextField { textfield in
                textfield.isSecureTextEntry = true
                textfield.autocorrectionType = .no
                textfield.autocapitalizationType = .none
                textfield.smartDashesType = .no
                textfield.spellCheckingType = .no
                textfield.font = UIFont.Body2
            }
            let action1 = UIAlertAction(title: "취소", style: .cancel) { _ in
                self.tableView.reloadData()
            }
            let action2 = UIAlertAction(title: "확인", style: .default) { _ in
                if let pwInfo = alert.textFields?[0].text, pwInfo.isEmpty == false, info.pw == pwInfo, let currentPost = FeedViewModel.shared.selectedFeedInfo {
                    DataAPIService.shared.removeCommentInPost(currentPost.id, info.id) { result in
                        DataAPIService.shared.fetchSpecificPost(currentPost.id) { result in
                            if result == 1 {
                                self.style()
                                self.tableView.reloadData()
                            }
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "", message: "비밀번호가 틀렸습니다", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.tableView.reloadData()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            alert.addAction(action1)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
        }
        let action3 = UIAlertAction(title: "취소", style: .cancel) {_ in
            self.tableView.reloadData()
        }
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension CommentsViewController {
    // MARK: - Keyboard up/down adjustment
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            commentViewBottom.constant = -(adjustmentHeight + 12)
            self.view.layoutIfNeeded()
        } else {
            commentViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
