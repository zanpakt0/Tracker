//
//  TabBarController.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 03.11.2025.
//

import UIKit

class TabBarController: UITabBarController {

    private let topBorderView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTopBorder()
    }

    private func setupTabBar() {
        let trackersViewController = TrackersViewController()
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab.trackers", comment: "Trackers tab"),
            image: UIImage(named: "TabBarActive"),
            selectedImage: UIImage(named: "TabBarActive")
        )

        let statisticsViewController = StatisticsViewController()
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab.statistics", comment: "Statistics tab"),
            image: UIImage(named: "TabBarStat"),
            selectedImage: UIImage(named: "TabBarStat")
        )

        viewControllers = [trackersNavigationController, statisticsNavigationController]

        tabBar.backgroundColor = UIColor(named: "WhiteDay")
        tabBar.tintColor = UIColor(named: "Blue")
        tabBar.unselectedItemTintColor = UIColor(named: "Gray")
    }

    private func setupTopBorder() {
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = UIColor(named: "Tabbarline")
        view.addSubview(topBorderView)

        NSLayoutConstraint.activate([
            topBorderView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -4),
            topBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

