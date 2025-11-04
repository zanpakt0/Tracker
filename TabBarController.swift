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
            title: "Трекеры",
            image: UIImage(named: "TabBarActive"),
            selectedImage: UIImage(named: "TabBarActive")
        )

        let statisticsViewController = StatisticsViewController()
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "TabBarStat"),
            selectedImage: UIImage(named: "TabBarStat")
        )

        viewControllers = [trackersNavigationController, statisticsNavigationController]

        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = UIColor(named: "Blue")
        tabBar.unselectedItemTintColor = UIColor(named: "Gray")
    }

    private func setupTopBorder() {
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = UIColor(named: "Gray")
        view.addSubview(topBorderView)

        NSLayoutConstraint.activate([
            topBorderView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -4),
            topBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - Placeholder View Controllers

class StatisticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let label = UILabel()
        label.text = "Статистика"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
    