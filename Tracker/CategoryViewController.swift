//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 05.11.2025.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(_ category: TrackerCategory)
}

protocol CategoryViewControllerContextMenuDelegate: AnyObject {
    func didTapEditCategory(_ category: TrackerCategory)
    func didTapDeleteCategory(_ category: TrackerCategory)
}

final class CategoryViewController: UIViewController {

    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let addCategoryButton = UIButton(type: .system)
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()

    // MARK: - Properties
    private var viewModel: CategoryViewModelProtocol
    weak var delegate: CategoryViewControllerDelegate?
    weak var contextMenuDelegate: CategoryViewControllerContextMenuDelegate?
    private var contextMenuView: CategoryContextMenuView?

    // MARK: - Initialization
    init(viewModel: CategoryViewModelProtocol = CategoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadCategories()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.white

        setupTitle()
        setupTableView()
        setupAddButton()
        setupEmptyState()
    }

    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Категория"
        titleLabel.font = UIFont(name: "SFPro-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(named: "BlackDay")
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }

    private func setupAddButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(UIColor.white, for: .normal)
        addCategoryButton.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.backgroundColor = UIColor(named: "BlackDay")
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.contentEdgeInsets = UIEdgeInsets(top: 19, left: 32, bottom: 19, right: 32)
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        view.addSubview(addCategoryButton)


        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20),

            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    private func setupEmptyState() {
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.image = UIImage(named: "Dizzy")
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.isHidden = true
        view.addSubview(emptyStateImageView)

        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "Привычки и события можно\nобъединить по смыслу"
        emptyStateLabel.font = UIFont(name: "SFPro-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        emptyStateLabel.textColor = UIColor(named: "BlackDay")
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),

            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 8),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupBindings() {
        viewModel.onCategoriesUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }

        viewModel.onCategorySelected = { [weak self] category in
            // НЕ вызываем делегата автоматически - только при ручном выборе
            // НЕ закрываем окно - пользователь должен сам выбрать категорию
        }

        viewModel.onCategoryCreated = { [weak self] category in
            // При создании новой категории автоматически выбираем её и обновляем UI
            DispatchQueue.main.async {
                self?.viewModel.selectCategory(category)
                // НЕ закрываем CategoryViewController - показываем список с новой категорией
            }
        }
    }

    // MARK: - UI Updates
    private func updateUI() {
        let hasCategories = !viewModel.categories.isEmpty
        tableView.isHidden = !hasCategories
        emptyStateImageView.isHidden = hasCategories
        emptyStateLabel.isHidden = hasCategories

        tableView.reloadData()
    }

    // MARK: - Actions
    @objc private func addCategoryButtonTapped() {
        let createCategoryVC = CreateCategoryViewController(viewModel: viewModel)
        createCategoryVC.modalPresentationStyle = .pageSheet
        present(createCategoryVC, animated: true)
    }

    // MARK: - Context Menu
    private func showContextMenu(for category: TrackerCategory, at indexPath: IndexPath) {
        hideContextMenu()

        let contextMenu = CategoryContextMenuView()
        contextMenu.delegate = self
        contextMenu.configure(with: category)
        contextMenu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contextMenu)

        let cellRect = tableView.rectForRow(at: indexPath)
        let cellBottomY = cellRect.maxY

        NSLayoutConstraint.activate([
            contextMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            contextMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: cellBottomY + 72)
        ])

        contextMenuView = contextMenu

        // Добавляем затемнение с "дыркой" для активной ячейки и контекстного меню
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.tag = 999
        view.insertSubview(dimView, belowSubview: contextMenu)

        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        DispatchQueue.main.async {
            let maskLayer = CAShapeLayer()
            let path = UIBezierPath(rect: dimView.bounds)

            let cellRect = self.tableView.rectForRow(at: indexPath)
            let cellRectInView = self.tableView.convert(cellRect, to: self.view)
            let cellHoleRect = CGRect(
                x: cellRectInView.minX + 16,
                y: cellRectInView.minY,
                width: cellRectInView.width - 32,
                height: cellRectInView.height
            )
            let cellHolePath = UIBezierPath(roundedRect: cellHoleRect, cornerRadius: 16)
            path.append(cellHolePath)

            let menuRect = contextMenu.convert(contextMenu.bounds, to: self.view)
            let menuHolePath = UIBezierPath(roundedRect: menuRect, cornerRadius: 13)
            path.append(menuHolePath)

            maskLayer.path = path.cgPath
            maskLayer.fillRule = .evenOdd
            dimView.layer.mask = maskLayer
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideContextMenu))
        dimView.addGestureRecognizer(tapGesture)
    }

    @objc private func hideContextMenu() {
        contextMenuView?.removeFromSuperview()
        contextMenuView = nil
        view.viewWithTag(999)?.removeFromSuperview()
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell

        let category = viewModel.categories[indexPath.row]
        let isSelected = viewModel.selectedCategory?.title == category.title
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == viewModel.categories.count - 1
        cell.configure(with: category, isSelected: isSelected, isFirst: isFirst, isLast: isLast)

        cell.onLongPress = { [weak self] category in
            self?.showContextMenu(for: category, at: indexPath)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        delegate?.didSelectCategory(category)
        dismiss(animated: true)
    }
}

// MARK: - CategoryContextMenuViewDelegate
extension CategoryViewController: CategoryContextMenuViewDelegate {
    func didTapEditCategory(_ category: TrackerCategory) {
        hideContextMenu()

        let editCategoryVC = EditCategoryViewController(category: category)
        editCategoryVC.delegate = self
        editCategoryVC.modalPresentationStyle = .pageSheet
        present(editCategoryVC, animated: true)
    }

    func didTapDeleteCategory(_ category: TrackerCategory) {
        hideContextMenu()

        let alert = UIAlertController(
            title: "Удалить категорию?",
            message: "Все трекеры в этой категории также будут удалены.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(category)
        })

        present(alert, animated: true)
    }
}

// MARK: - EditCategoryViewControllerDelegate
extension CategoryViewController: EditCategoryViewControllerDelegate {
    func didUpdateCategory(_ category: TrackerCategory, newTitle: String) {
        viewModel.updateCategoryTitle(category, newTitle: newTitle)
    }
}
