//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 03.11.2025.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private let searchContainerView = UIView()
    private let searchTextField = UITextField()
    private let searchIconView = UIImageView()
    private let datePicker = UIDatePicker()
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let categoryHeaderLabel = UILabel()

    // MARK: - Data
    private var categories: [TrackerCategory] = []
    private var completedTrackerIds: Set<UUID> = []
    var currentDate: Date = Date()

    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let recordStore = TrackerRecordStore()

    // MARK: - Computed Properties
    private var visibleCategories: [TrackerCategory] {
        let result = categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let isScheduled = tracker.isScheduled(for: currentDate)
                return isScheduled
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }

        return result
    }

    private var visibleTrackers: [Tracker] {
        var allTrackers: [Tracker] = []
        for category in categories {
            allTrackers.append(contentsOf: category.trackers)
        }
        return allTrackers.filter { $0.isScheduled(for: currentDate) }
    }

    private func getCompletedCount(for tracker: Tracker) -> Int {
        return recordStore.getCompletedCount(for: tracker.id)
    }

    private func isTrackerCompleted(for tracker: Tracker) -> Bool {
        return recordStore.isTrackerCompleted(trackerId: tracker.id, date: currentDate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        startObservingDataChanges()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingDataChanges()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "WhiteDay")
        setupNavigationBar()
        setupAddButton()
        setupTitle()
        setupSearchBar()
        setupDatePicker()
        setupCategoryHeader()
        setupCollectionView()
        setupEmptyState()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont(name: "SFPro-Bold", size: 34) ?? UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textColor = UIColor(named: "BlackDay")
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41)
        ])
    }

    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named: "Add tracker"), for: .normal)
        addButton.tintColor = UIColor.black
        addButton.backgroundColor = UIColor.clear
        addButton.alpha = 1.0
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = currentDate
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func setupCategoryHeader() {
        categoryHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryHeaderLabel.text = ""
        categoryHeaderLabel.font = UIFont(name: "SFPro-Bold", size: 19) ?? UIFont.boldSystemFont(ofSize: 19)
        categoryHeaderLabel.textColor = UIColor(named: "BlackDay")
        categoryHeaderLabel.isHidden = true
        view.addSubview(categoryHeaderLabel)

        NSLayoutConstraint.activate([
            categoryHeaderLabel.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 34),
            categoryHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            categoryHeaderLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    private func setupSearchBar() {
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.backgroundColor = UIColor(named: "LightGray")
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.clipsToBounds = true
        view.addSubview(searchContainerView)

        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(named: "Gray")
        searchContainerView.addSubview(searchIconView)

        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Поиск"
        searchTextField.backgroundColor = .clear
        searchTextField.borderStyle = .none
        searchTextField.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = UIColor(named: "Gray")
        searchContainerView.addSubview(searchTextField)

        NSLayoutConstraint.activate([
            searchContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),

            searchIconView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchIconView.widthAnchor.constraint(equalToConstant: 15.63),
            searchIconView.heightAnchor.constraint(equalToConstant: 15.78),

            searchTextField.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -7)
        ])
    }

    private func setupEmptyState() {
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.image = UIImage(named: "Dizzy")
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.alpha = 1.0
        view.addSubview(emptyStateImageView)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "Что будем отслеживать?"
        emptyStateLabel.font = UIFont.systemFont(ofSize: 12)
        emptyStateLabel.textColor = UIColor(named: "BlackDay")
        emptyStateLabel.textAlignment = .center
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 8),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Actions

    @objc private func addButtonTapped() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.delegate = self
        createHabitViewController.modalPresentationStyle = .pageSheet
        present(createHabitViewController, animated: true)
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        updateUI()
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.identifier)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        collectionView.setCollectionViewLayout(layout, animated: false)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: categoryHeaderLabel.bottomAnchor, constant: 6),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Data Management
    private func startObservingDataChanges() {
        categoryStore.startObservingChanges { [weak self] categories in
            DispatchQueue.main.async {
                self?.categories = categories
                self?.updateUI()
            }
        }
    }

    private func stopObservingDataChanges() {
        categoryStore.stopObservingChanges()
    }

    private func loadData() {
        categories = categoryStore.fetchCategories()
        updateUI()
    }

    private func addTracker(_ tracker: Tracker, category: TrackerCategory) {
        _ = trackerStore.createTracker(
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            schedule: tracker.schedule,
            categoryTitle: category.title
        )
        loadData()
    }

        private func updateCategoryHeader() {
        if let firstCategory = visibleCategories.first {
            categoryHeaderLabel.text = firstCategory.title
        }
    }

    func updateUI() {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()

        let isEmpty = visibleCategories.isEmpty

        emptyStateImageView.isHidden = !isEmpty
        emptyStateLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
        categoryHeaderLabel.isHidden = true
    }

    // MARK: - Tracker Management
    private func toggleTrackerCompletion(for tracker: Tracker) {
        let calendar = Calendar.current
        let today = Date()

        let canBeCompleted = calendar.compare(currentDate, to: today, toGranularity: .day) != .orderedDescending

        if !canBeCompleted {
            return
        }

        recordStore.toggleTrackerCompletion(trackerId: tracker.id, date: currentDate)
        updateUI()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = visibleCategories[section]
        return category.trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as! TrackerCollectionViewCell
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.item]
        let completedCount = getCompletedCount(for: tracker)
        let isCompleted = isTrackerCompleted(for: tracker)

        cell.onCompletionToggled = { [weak self] tracker in
            self?.toggleTrackerCompletion(for: tracker)
        }

        cell.configure(with: tracker, selectedDate: currentDate, isCompleted: isCompleted, completedCount: completedCount)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoryHeader", for: indexPath) as! CategoryHeaderView
            let category = visibleCategories[indexPath.section]
            headerView.configure(with: category.title)
            return headerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = collectionView.bounds.width

        if collectionViewWidth == 0 {

            let screenWidth = UIScreen.main.bounds.width
            let availableWidth = screenWidth - 32
            let spacing: CGFloat = 9
            let cellWidth = (availableWidth - spacing) / 2

            return CGSize(width: cellWidth, height: 132)
        } else {
            let availableWidth = collectionViewWidth - 32
            let spacing: CGFloat = 9
            let cellWidth = (availableWidth - spacing) / 2

            return CGSize(width: cellWidth, height: 132)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
}

// MARK: - CreateHabitViewControllerDelegate
extension TrackersViewController: CreateHabitViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, category: TrackerCategory) {
        addTracker(tracker, category: category)
    }
}
