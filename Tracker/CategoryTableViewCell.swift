//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 05.11.2025.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()

    // MARK: - Properties
    static let identifier = "CategoryCell"
    var onLongPress: ((TrackerCategory) -> Void)?
    private var category: TrackerCategory?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        containerView.layer.cornerRadius = 16
        contentView.addSubview(containerView)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        containerView.addGestureRecognizer(longPressGesture)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor(named: "BlackDay")
        titleLabel.numberOfLines = 1
        containerView.addSubview(titleLabel)

        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = UIColor(named: "Blue")
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.isHidden = true
        containerView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 75),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -16),

            checkmarkImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    // MARK: - Configuration
    func configure(with category: TrackerCategory, isSelected: Bool, isFirst: Bool, isLast: Bool) {
        titleLabel.text = category.title
        checkmarkImageView.isHidden = !isSelected

        self.category = category

        containerView.subviews.forEach { subview in
            if subview != titleLabel && subview != checkmarkImageView {
                subview.removeFromSuperview()
            }
        }

        if isFirst && isLast {
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if isFirst {
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            containerView.layer.maskedCorners = []
        }

        if !isLast {
            let separatorView = UIView()
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.backgroundColor = UIColor(named: "Gray")
            containerView.addSubview(separatorView)

            NSLayoutConstraint.activate([
                separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        checkmarkImageView.isHidden = true
        category = nil
    }

    // MARK: - Actions
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let category = category else { return }
            onLongPress?(category)
        }
    }
}
