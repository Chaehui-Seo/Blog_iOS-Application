//
//  MainPageViewController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/10/30.
//

import Foundation
import UIKit
import Combine

class MainPageViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var headerViewTop: NSLayoutConstraint!
    @IBOutlet weak var headerView: MainPageHeaderView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var blogInfoEditButton: UIButton!

    // 피드 관련 뷰
    let separatorView = UIView()
    let scrollView = UIScrollView()
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    let feedView = UIView()
    var feedViewHeight: NSLayoutConstraint!
    let noFeedLabel = UILabel()
    
    // 피드 상단에 위치한 버튼 및 label
    let listTitleLabel = UILabel()
    let listSortButton = UIButton()
    let squareSortButton = UIButton()
    @Published var sortType = 0
        
    // 새로고침 관련
    private let refreshControl = UIRefreshControl()
    
    var safeTop: CGFloat!
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - VC LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeTop = self.view.safeAreaInsets.top
        headerViewTop.constant = -safeTop
        scrollView.layer.cornerRadius = 30
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedListingCell.self, forCellReuseIdentifier: "FeedListingCell")
        tableView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(FeedSquareCell.self, forCellWithReuseIdentifier: "FeedSquareCell")
        style()
        layout()
        setAction()
        
        refreshSet()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FeedViewModel.shared.selectedFeedInfo = nil
    }
    
    // MARK: - UI Setting
    func style() {
        blogInfoEditButton.setTitle("", for: .normal)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        
        feedView.translatesAutoresizingMaskIntoConstraints = false
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.lightGray
        separatorView.alpha = 0
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumInteritemSpacing = 5
        collectionViewLayout.minimumLineSpacing = 5
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
        
        noFeedLabel.translatesAutoresizingMaskIntoConstraints = false
        noFeedLabel.font = UIFont.Body1
        noFeedLabel.text = "게시글이 없습니다"
        noFeedLabel.isHidden = true
        
        listSortButton.translatesAutoresizingMaskIntoConstraints = false
        listSortButton.setImage(UIImage(systemName: "rectangle.grid.1x2.fill"), for: .normal)
        listSortButton.tintColor = UIColor.gray
        if #available(iOS 15.0, *) {
            listSortButton.configuration = .plain()
        }
        
        squareSortButton.translatesAutoresizingMaskIntoConstraints = false
        squareSortButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        squareSortButton.tintColor = UIColor.gray
        if #available(iOS 15.0, *) {
            squareSortButton.configuration = .plain()
        }
        
        listTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        listTitleLabel.font = UIFont.Head3
        listTitleLabel.text = "전체글"
    }
    
    func layout() {
        self.view.addSubview(scrollView)
        self.view.addSubview(separatorView)
        self.scrollView.addSubview(feedView)
        self.scrollView.addSubview(tableView)
        self.scrollView.addSubview(collectionView)
        self.scrollView.addSubview(squareSortButton)
        self.scrollView.addSubview(listSortButton)
        self.scrollView.addSubview(listTitleLabel)
        self.scrollView.addSubview(noFeedLabel)
        
        feedViewHeight = feedView.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -60),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            feedView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 60),
            feedView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            feedView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            feedViewHeight,

            separatorView.bottomAnchor.constraint(equalTo: self.scrollView.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            separatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            noFeedLabel.topAnchor.constraint(equalTo: self.feedView.topAnchor, constant: 100),
            noFeedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: self.feedView.topAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -40),
            
            collectionView.topAnchor.constraint(equalTo: self.feedView.topAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            
            squareSortButton.bottomAnchor.constraint(equalTo: self.tableView.topAnchor, constant: -10),
            squareSortButton.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: -25),
            squareSortButton.widthAnchor.constraint(equalToConstant: 41),
            squareSortButton.heightAnchor.constraint(equalToConstant: 41),
            
            listSortButton.bottomAnchor.constraint(equalTo: self.tableView.topAnchor, constant: -10),
            listSortButton.trailingAnchor.constraint(equalTo: self.squareSortButton.leadingAnchor, constant: -5),
            listSortButton.widthAnchor.constraint(equalToConstant: 41),
            listSortButton.heightAnchor.constraint(equalToConstant: 41),
            
            listTitleLabel.centerYAnchor.constraint(equalTo: self.listSortButton.centerYAnchor),
            listTitleLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 35)
        ])
    }
    
    // MARK: - Refresh Setting
    // Refresh function is called when scrolled down
    func refreshSet(){
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        fetchInfo()
    }
    
    private func fetchInfo() {
        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global().async {
            DataAPIService.shared.fetchBlogInfo {
                group.leave()
            }
        }

        group.enter()
        DispatchQueue.global().async {
            DataAPIService.shared.fetchFeed { result in
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.headerView.setUI(BlogInfoViewModel.shared.blogInfo.title, BlogInfoViewModel.shared.blogInfo.intro)
            }
        }
    }
    
    // MARK: - Bind data in viewmodel
    private func bindViewModel() {
        FeedViewModel.shared.$feedInfo.receive(on: RunLoop.main)
            .sink {[weak self] feedInfo in
                guard let self = self else { return }
                if self.sortType == 0 {
                    self.tableView.reloadData()
                } else {
                    self.collectionView.reloadData()
                }
            }.store(in: &cancellable)
        BlogInfoViewModel.shared.$blogInfo.receive(on: RunLoop.main)
            .sink { [weak self] blogInfo in
                guard let self = self else { return }
                self.headerView.setUI(BlogInfoViewModel.shared.blogInfo.title, BlogInfoViewModel.shared.blogInfo.intro)
                self.thumbnailImageView.contentMode = .scaleAspectFill
                self.thumbnailImageView.clipsToBounds = true
                if blogInfo.imageType != "0" && blogInfo.imageType != "No" {
                    self.thumbnailImageView.image = UIImage(named: "image\(blogInfo.imageType)")
                    return
                }
                if let imageData = BlogInfoViewModel.shared.blogInfo.thumbnail {
                    self.thumbnailImageView.image = UIImage(data: imageData)
                } else {
                    self.thumbnailImageView.image = UIImage(named: "noImage_long")
                }
            }.store(in: &cancellable)
        $sortType.receive(on: RunLoop.main)
            .sink { [weak self] sortInfo in
                guard let self = self else { return }
                if sortInfo == 0 {
                    self.tableView.reloadData()
                    self.collectionView.isHidden = true
                    self.tableView.isHidden = false
                    self.listSortButton.setImage(UIImage(systemName: "rectangle.grid.1x2.fill"), for: .normal)
                    self.squareSortButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
                } else {
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = false
                    self.tableView.isHidden = true
                    self.listSortButton.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)
                    self.squareSortButton.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
                }
            }.store(in: &cancellable)
    }
    
    // MARK: - Button Action
    func setAction() {
        listSortButton.addTarget(self, action: #selector(listSortButtonClicked), for: .touchUpInside)
        squareSortButton.addTarget(self, action: #selector(squareSortButtonClicked), for: .touchUpInside)
        blogInfoEditButton.addTarget(self, action: #selector(blogInfoEditButtonClicked), for: .touchUpInside)
    }
    
    @objc private func listSortButtonClicked() {
        sortType = 0
    }

    @objc private func squareSortButtonClicked() {
        sortType = 1
    }
    
    @objc private func addButtonClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let writeVC = storyboard.instantiateViewController(withIdentifier: "PostWriteViewController") as? PostWriteViewController else { return }
        writeVC.modalPresentationStyle = .fullScreen
        self.present(writeVC, animated: true, completion: nil)
    }
    
    @objc private func blogInfoEditButtonClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editVC = storyboard.instantiateViewController(withIdentifier: "BlogInfoEditViewController") as? BlogInfoEditViewController else { return }
        editVC.modalPresentationStyle = .fullScreen
        self.present(editVC, animated: true, completion: nil)
    }
}

extension MainPageViewController: UIScrollViewDelegate {
    // MARK: - UI Changing while scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let topBar = safeTop + 119
        let currentPosition = (300 - topBar) / 2
        if y <= currentPosition {
            if y > 0 {
                headerViewHeight.constant = (300 - (y * 2))
                headerView.titleLabel.alpha =  1 - (y / currentPosition)
                thumbnailImageView.alpha = 1 - (y / currentPosition)
                headerView.introductionLabel.alpha =  1 - (y / currentPosition)
                let transparenct = 1 - (y / currentPosition)
                headerView.centeredTitleLabel.alpha = 1 -  transparenct
                headerView.backgroundColor = UIColor(red: 0.154, green: 0.154, blue: 0.154, alpha: 1).withAlphaComponent(0.5 * transparenct)
            } else {
                headerViewHeight.constant = 300
                headerView.titleLabel.alpha =  1
                thumbnailImageView.alpha = 1
                headerView.introductionLabel.alpha =  1
                headerView.centeredTitleLabel.alpha = 0
                headerView.backgroundColor = UIColor(red: 0.154, green: 0.154, blue: 0.154, alpha: 1).withAlphaComponent(0.5)
            }
            separatorView.alpha = 0
            scrollView.layer.cornerRadius = 30
            blogInfoEditButton.tintColor = UIColor.white
            self.view.layoutIfNeeded()
        } else {
            headerViewHeight.constant = topBar
            headerView.titleLabel.alpha =  0
            headerView.introductionLabel.alpha =  0
            headerView.centeredTitleLabel.alpha = 1
            separatorView.alpha = 1
            thumbnailImageView.alpha = 0
            headerView.backgroundColor = UIColor(red: 0.154, green: 0.154, blue: 0.154, alpha: 1).withAlphaComponent(0)
            scrollView.layer.cornerRadius = 0
            blogInfoEditButton.tintColor = UIColor.black
            self.view.layoutIfNeeded()
        }
    }
}

extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let newHeight = CGFloat((FeedViewModel.shared.feedInfo.count * 140) + 80)
        if (UIScreen.main.bounds.height) > newHeight {
            self.feedViewHeight.constant = UIScreen.main.bounds.height
        } else {
            self.feedViewHeight.constant = newHeight
        }
        noFeedLabel.isHidden = !(FeedViewModel.shared.feedInfo.count == 0)
        return FeedViewModel.shared.feedInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListingCell", for: indexPath) as? FeedListingCell else { return UITableViewCell()}
        cell.style()
        cell.layout()
        cell.updateUI(FeedViewModel.shared.feedInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let specificVC = storyboard.instantiateViewController(withIdentifier: "SpecificPostViewController") as? SpecificPostViewController else { return }
        FeedViewModel.shared.selectedFeedInfo = FeedViewModel.shared.feedInfo[indexPath.row]
        specificVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(specificVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MainPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let row = Double(FeedViewModel.shared.feedInfo.count) / 3.0
        let ceilRow = ceil(row)
        let height = (UIScreen.main.bounds.width - 10) / 3
        let newHeight = CGFloat( (ceilRow * (height + 5)) + 80)
        if (UIScreen.main.bounds.height) > newHeight {
            self.feedViewHeight.constant = UIScreen.main.bounds.height - 59
        } else {
            self.feedViewHeight.constant = newHeight
        }
        noFeedLabel.isHidden = !(FeedViewModel.shared.feedInfo.count == 0)
        return FeedViewModel.shared.feedInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedSquareCell", for: indexPath) as? FeedSquareCell else {
            return UICollectionViewCell()
        }
        cell.style()
        cell.layout()
        cell.updateUI(FeedViewModel.shared.feedInfo[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let specificVC = storyboard.instantiateViewController(withIdentifier: "SpecificPostViewController") as? SpecificPostViewController else { return }
        FeedViewModel.shared.selectedFeedInfo = FeedViewModel.shared.feedInfo[indexPath.item]
        specificVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(specificVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 10) / 3
        return CGSize(width: width, height: width)
    }
}

