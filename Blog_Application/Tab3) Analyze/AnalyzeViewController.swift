//
//  AnalyzeViewController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/03.
//

import Foundation
import UIKit
import Combine
import Charts

class AnalyzeViewController: UIViewController, ChartViewDelegate {
    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var currentAnalyzeTitleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    // 그래프 및 리스팅 관련 UI
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var lightGrayView: UIView!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // 현재 선택된 카테고리 (조회수 / 댓글수)
    let hitCategoryButton = UIButton()
    let commentCategoryButton = UIButton()
    @Published var currentAnalyze = 0
    
    var totalPercertage = 0
    var hitCategoryList: [HitInfo] = []
    var commentCategoryList: [Feed] = []
    
    // 새로고침 컨트롤러
    private let refreshControl = UIRefreshControl()
    
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RankCell.self, forCellReuseIdentifier: "RankCell")
        pieChart.delegate = self
        style()
        layout()
        setAction()
        binding()
        refreshSet()
        DataAPIService.shared.fetchPostHits { _ in
            DataAPIService.shared.fetchFeed { _ in
                self.currentAnalyze = 0
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FeedViewModel.shared.selectedFeedInfo = nil
    }
    
    // MARK: - UI Setting
    func style() {
        titleLabel.font = UIFont.Head3
        
        pieChart.rotationEnabled = false
        
        noDataLabel.font = UIFont.Body1
        noDataLabel.isHidden = true
        
        hitCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        hitCategoryButton.setTitle("조회수", for: .normal)
        hitCategoryButton.titleLabel?.font = UIFont.Head3
        hitCategoryButton.setTitleColor(UIColor.systemGray5, for: .normal)
        hitCategoryButton.layer.cornerRadius = 5
        
        commentCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        commentCategoryButton.setTitle("댓글수", for: .normal)
        commentCategoryButton.titleLabel?.font = UIFont.Head3
        commentCategoryButton.setTitleColor(UIColor.systemGray5, for: .normal)
        commentCategoryButton.layer.cornerRadius = 5
        
        currentAnalyzeTitleLabel.font = UIFont.Body1
        currentAnalyzeTitleLabel.textColor = UIColor.darkGray
        
        tableView.layer.borderColor = UIColor.systemGray6.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 5
        
        countLabel.font = UIFont.Head1
        
        lightGrayView.layer.cornerRadius = 20
        
        updatedDateLabel.font = UIFont.Body3
        updatedDateLabel.textColor = UIColor.lightGray
    }
    
    func layout() {
        self.innerView.addSubview(hitCategoryButton)
        self.innerView.addSubview(commentCategoryButton)
        
        NSLayoutConstraint.activate([
            hitCategoryButton.topAnchor.constraint(equalTo: self.innerView.topAnchor, constant: 20),
            hitCategoryButton.leadingAnchor.constraint(equalTo: self.innerView.leadingAnchor, constant: 50),
            hitCategoryButton.widthAnchor.constraint(equalToConstant: 60),
            
            commentCategoryButton.topAnchor.constraint(equalTo: self.innerView.topAnchor, constant: 20),
            commentCategoryButton.leadingAnchor.constraint(equalTo: self.hitCategoryButton.trailingAnchor, constant: 5),
            commentCategoryButton.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    // MARK: - Bind Data
    func binding() {
        $currentAnalyze.receive(on: RunLoop.main)
            .sink { [weak self] current in
                guard let self = self else { return }
                switch current {
                case 0:
                    self.updateHitRank()
                default:
                    self.updateCommentRank()
                    
                }
            }.store(in: &cancellable)
        FeedViewModel.shared.$hitInfo.receive(on: RunLoop.main)
            .sink { [weak self] hitInfo in
                guard let self = self else { return }
                if self.currentAnalyze == 0 {
                    self.updateHitRank()
                }
            }.store(in: &cancellable)
        FeedViewModel.shared.$feedInfo.receive(on: RunLoop.main)
            .sink { [weak self] feedInfo in
                guard let self = self else { return }
                switch self.currentAnalyze {
                case 0:
                    DataAPIService.shared.fetchPostHits { _ in
                    }
                default:
                    self.updateCommentRank()
                }
            }.store(in: &cancellable)
    }
    
    // MARK: - Update UI
    func updateHitRank() {
        self.hitCategoryButton.backgroundColor = UIColor.mainLightOrange
        self.hitCategoryButton.setTitleColor(UIColor.white, for: .normal)
        self.commentCategoryButton.backgroundColor = UIColor.clear
        self.commentCategoryButton.setTitleColor(UIColor.systemGray5, for: .normal)
        self.totalPercertage = 0
        self.hitCategoryList = []
        self.hitCategoryList = FeedViewModel.shared.hitInfo.sorted { $0.hitNum > $1.hitNum }
        var hitNums: [Int] = []
        for i in self.hitCategoryList {
            self.totalPercertage += i.hitNum
            hitNums.append(i.hitNum)
        }
        self.countLabel.text = "\(self.totalPercertage)회"
        self.pieChart.isHidden = (self.totalPercertage == 0)
        self.noDataLabel.isHidden = !(self.totalPercertage == 0)
        self.currentAnalyzeTitleLabel.text = "총 게시글 조회수"
        self.updatedDateLabel.text = "마지막 업데이트 일시: \(FeedViewModel.shared.hitLastUpdatedDate)"
        self.updatePieChart(hitNums)
    }
    
    func updateCommentRank() {
        self.commentCategoryButton.backgroundColor = UIColor.mainLightOrange
        self.commentCategoryButton.setTitleColor(UIColor.white, for: .normal)
        self.hitCategoryButton.backgroundColor = UIColor.clear
        self.hitCategoryButton.setTitleColor(UIColor.systemGray5, for: .normal)
        self.totalPercertage = 0
        self.commentCategoryList = []
        self.commentCategoryList = FeedViewModel.shared.feedInfo.filter { $0.comments.count > 0 }.sorted { $0.comments.count > $1.comments.count }
        var commentNums: [Int] = []
        for i in self.commentCategoryList {
            self.totalPercertage += i.comments.count
            commentNums.append(i.comments.count)
        }
        self.countLabel.text = "\(self.totalPercertage)회"
        self.pieChart.isHidden = (self.totalPercertage == 0)
        self.noDataLabel.isHidden = !(self.totalPercertage == 0)
        self.currentAnalyzeTitleLabel.text = "총 댓글수"
        self.updatedDateLabel.text = "마지막 업데이트 일시: \(FeedViewModel.shared.commentLastUpdatedDate)"
        self.updatePieChart(commentNums)
    }
    
    // MARK: - Update pie chart
    func updatePieChart(_ numInfo: [Int]) {
        var entries = [ChartDataEntry]()
        for i in numInfo {
            let percentageInfo = Double(i) / Double(totalPercertage)
            let percentageNum = String(format: "%.1f", (percentageInfo * 100))
            entries.append(ChartDataEntry(x: Double(percentageNum) ?? 0, y: Double(percentageNum) ?? 0))
        }
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        
        self.tableViewHeight.constant = CGFloat(50 * numInfo.count)
        self.tableView.reloadData()
    }
    
    // MARK: - Button Action
    func setAction() {
        hitCategoryButton.addTarget(self, action: #selector(hitSortClicked), for: .touchUpInside)
        commentCategoryButton.addTarget(self, action: #selector(commentSortClicked), for: .touchUpInside)
    }
    
    @objc func hitSortClicked() {
        DataAPIService.shared.fetchPostHits { _ in
            DataAPIService.shared.fetchFeed { _ in
                self.currentAnalyze = 0
            }
        }
    }
    
    @objc func commentSortClicked() {
        DataAPIService.shared.fetchFeed { _ in
            self.currentAnalyze = 1
        }
    }
    
    // MARK: - Refresh
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
        switch currentAnalyze {
        case 0:
            DataAPIService.shared.fetchPostHits { _ in
                DataAPIService.shared.fetchFeed { _ in
                    self.refreshControl.endRefreshing()
                    self.currentAnalyze = 0
                }
            }
        default:
            DataAPIService.shared.fetchFeed { _ in
                self.refreshControl.endRefreshing()
                self.currentAnalyze = 1
            }
        }
    }
}

extension AnalyzeViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentAnalyze == 0 {
            return hitCategoryList.count
        } else {
            return commentCategoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as? RankCell else {
            return UITableViewCell()
        }
        cell.style()
        cell.layout()
        if currentAnalyze == 0 {
            cell.updateUI(percentage: Double(hitCategoryList[indexPath.row].hitNum) / Double(totalPercertage), feed: FeedViewModel.shared.findPostWithId(hitCategoryList[indexPath.row].postId))
        } else {
            cell.updateUI(percentage: Double(commentCategoryList[indexPath.row].comments.count) / Double(totalPercertage), feed: commentCategoryList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var feedInfo: Feed?
        if currentAnalyze == 0 {
            feedInfo = FeedViewModel.shared.findPostWithId(hitCategoryList[indexPath.row].postId)
        } else {
            feedInfo = commentCategoryList[indexPath.row]
        }
        guard let currentFeedInfo = feedInfo else {return }
        FeedViewModel.shared.selectedFeedInfo = currentFeedInfo
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let specificVC = storyboard.instantiateViewController(withIdentifier: "SpecificPostViewController") as? SpecificPostViewController else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        specificVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(specificVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
