//
//  CategoryHeaderView.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 05.11.2025.
//

import UIKit

final class CategoryHeaderView: UICollectionReusableView {

    // MARK: - UI Elements
    private let titleLabel = UILabel()

    // MARK: - Properties
    static let identifier = "CategoryHeader"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.clear

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "SFPro-Bold", size: 19) ?? UIFont.boldSystemFont(ofSize: 19)
        titleLabel.textColor = UIColor(named: "BlackDay")
        titleLabel.textAlignment = .left
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuration
    func configure(with title: String) {
        titleLabel.text = title
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
