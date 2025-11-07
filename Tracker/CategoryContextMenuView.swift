//
//  CategoryContextMenuView.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 05.11.2025.
//

import UIKit

protocol CategoryContextMenuViewDelegate: AnyObject {
    func didTapEditCategory(_ category: TrackerCategory)
    func didTapDeleteCategory(_ category: TrackerCategory)
}

final class CategoryContextMenuView: UIView {

    // MARK: - UI Elements
    private let containerView = UIView()
    private let editButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let separatorView = UIView()

    // MARK: - Properties
    weak var delegate: CategoryContextMenuViewDelegate?
    private var category: TrackerCategory?

    // MARK: - Initialization
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

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(named: "LightGray")
        containerView.layer.cornerRadius = 13
        addSubview(containerView)

        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setTitle(NSLocalizedString("category.context.edit", comment: "Редактировать"), for: .normal)
        editButton.setTitleColor(UIColor(named: "BlackDay"), for: .normal)
        editButton.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        editButton.backgroundColor = UIColor.clear
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        containerView.addSubview(editButton)

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(named: "Gray")?.withAlphaComponent(0.3)
        containerView.addSubview(separatorView)

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle(NSLocalizedString("category.context.delete", comment: "Удалить"), for: .normal)
        deleteButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        deleteButton.backgroundColor = UIColor.clear
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        containerView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 250),
            containerView.heightAnchor.constraint(equalToConstant: 96),

            editButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            editButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 48),

            separatorView.topAnchor.constraint(equalTo: editButton.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            deleteButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    // MARK: - Configuration
    func configure(with category: TrackerCategory) {
        self.category = category
    }

    // MARK: - Actions
    @objc private func editButtonTapped() {
        guard let category = category else { return }
        delegate?.didTapEditCategory(category)
    }

    @objc private func deleteButtonTapped() {
        guard let category = category else { return }
        delegate?.didTapDeleteCategory(category)
    }
}
