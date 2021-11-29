//
//  TabBarController.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/11/04.
//

import Foundation
import UIKit
import Combine

class MainTabBarController: UITabBarController {
    let loadingView = UIView()
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        style()
        layout()
        
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
                self.loadingView.isHidden = true
            }
        }
    }
    
    // MARK: - UI setting
    func style() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor.mainLightOrange
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
        self.tabBar.barTintColor = UIColor.white
    }
    
    func layout() {
        self.view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    // MARK: TabBar selected
    // Present writing Viewcontroller modally
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController as? PostWriteViewController)  != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let VC = storyboard.instantiateViewController(withIdentifier: "PostWriteViewController") as? PostWriteViewController else { return false }
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
}

