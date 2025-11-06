//
//  TrackersViewControllerSnapshotTests.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 06.11.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {

    func testTrackersViewControllerEmptyState() {

        let mockViewModel = MockTrackerViewModel()
        let viewController = TrackersViewController(viewModel: mockViewModel)

        viewController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 812)

        viewController.loadViewIfNeeded()

        assertSnapshot(matching: viewController, as: .image(on: .iPhone13))
    }

    func testTrackersViewControllerWithData() {

        let mockViewModel = MockTrackerViewModel()
        mockViewModel.mockCategories = createTestCategories()

        let viewController = TrackersViewController(viewModel: mockViewModel)

        viewController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 812)

        viewController.loadViewIfNeeded()

        assertSnapshot(matching: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Helper Methods

    private func createTestCategories() -> [TrackerCategory] {
        let tracker1 = Tracker(
            name: "Пить воду",
            color: "Blue",
            emoji: "💧",
            schedule: [0, 1, 2, 3, 4, 5, 6]
        )

        let tracker2 = Tracker(
            name: "Читать книги",
            color: "Green",
            emoji: "📚",
            schedule: [1, 3, 5]
        )

        let category1 = TrackerCategory(title: "Здоровье", trackers: [tracker1])
        let category2 = TrackerCategory(title: "Образование", trackers: [tracker2])

        return [category1, category2]
    }
}

// MARK: - Mock TrackerViewModel

class MockTrackerViewModel: TrackerViewModelProtocol {
    var mockCategories: [TrackerCategory] = []

    var categories: [TrackerCategory] {
        return mockCategories
    }

    var onCategoriesUpdate: (() -> Void)?

    func loadData() {
        onCategoriesUpdate?()
    }

    func createTracker(_ tracker: Tracker, category: TrackerCategory) {
    }

    func updateTracker(_ tracker: Tracker, newName: String, newEmoji: String, newColor: String, newSchedule: [Int], newCategory: TrackerCategory?) {
    }

    func deleteTracker(_ tracker: Tracker) {
    }
}
