//
//  AnalyticsManager.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 06.11.2025.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private init() {}

    // MARK: - AppMetrica Events (согласно требованиям учебника)

    func trackScreenOpen(screen: String) {
        let parameters: [String: Any] = [
            "event": "open",
            "screen": screen
        ]

        YMMYandexMetrica.reportEvent("event", parameters: parameters)

        #if DEBUG
        print("📊 Отправлено событие: screen_open - \(screen)")
        #endif
    }

    func trackScreenClose(screen: String) {
        let parameters: [String: Any] = [
            "event": "close",
            "screen": screen
        ]

        YMMYandexMetrica.reportEvent("event", parameters: parameters)

        #if DEBUG
        print("📊 Отправлено событие: screen_close - \(screen)")
        #endif
    }

    func trackButtonClick(screen: String, item: String) {
        let parameters: [String: Any] = [
            "event": "click",
            "screen": screen,
            "item": item
        ]

        YMMYandexMetrica.reportEvent("event", parameters: parameters)

        #if DEBUG
        print("📊 Отправлено событие: button_click - \(screen)/\(item)")
        #endif
    }

    // MARK: - Legacy Events (оставляем для совместимости)

    func trackTrackerCreated(name: String, category: String, schedule: [Int]) {
        let parameters: [String: Any] = [
            "tracker_name": name,
            "category": category,
            "schedule_days": schedule.count,
            "is_daily": schedule.count == 7
        ]

        YMMYandexMetrica.reportEvent("tracker_created", parameters: parameters)
    }

    func trackTrackerCompleted(trackerId: UUID, trackerName: String) {
        let parameters: [String: Any] = [
            "tracker_id": trackerId.uuidString,
            "tracker_name": trackerName
        ]

        YMMYandexMetrica.reportEvent("tracker_completed", parameters: parameters)
    }

    func trackTrackerUncompleted(trackerId: UUID, trackerName: String) {
        let parameters: [String: Any] = [
            "tracker_id": trackerId.uuidString,
            "tracker_name": trackerName
        ]

        YMMYandexMetrica.reportEvent("tracker_uncompleted", parameters: parameters)
    }

    func trackTrackerEdited(trackerId: UUID, trackerName: String) {
        let parameters: [String: Any] = [
            "tracker_id": trackerId.uuidString,
            "tracker_name": trackerName
        ]

        YMMYandexMetrica.reportEvent("tracker_edited", parameters: parameters)
    }

    func trackTrackerDeleted(trackerId: UUID, trackerName: String) {
        let parameters: [String: Any] = [
            "tracker_id": trackerId.uuidString,
            "tracker_name": trackerName
        ]

        YMMYandexMetrica.reportEvent("tracker_deleted", parameters: parameters)
    }

    // MARK: - Category Events
    func trackCategoryCreated(categoryName: String) {
        let parameters: [String: Any] = [
            "category_name": categoryName
        ]

        YMMYandexMetrica.reportEvent("category_created", parameters: parameters)
    }

    func trackCategoryEdited(oldName: String, newName: String) {
        let parameters: [String: Any] = [
            "old_category_name": oldName,
            "new_category_name": newName
        ]

        YMMYandexMetrica.reportEvent("category_edited", parameters: parameters)
    }

    func trackCategoryDeleted(categoryName: String) {
        let parameters: [String: Any] = [
            "category_name": categoryName
        ]

        YMMYandexMetrica.reportEvent("category_deleted", parameters: parameters)
    }

    // MARK: - Screen Events
    func trackScreenView(screenName: String) {
        let parameters: [String: Any] = [
            "screen_name": screenName
        ]

        YMMYandexMetrica.reportEvent("screen_view", parameters: parameters)
    }

    func trackStatisticsViewed() {
        YMMYandexMetrica.reportEvent("statistics_viewed")
    }

    func trackFiltersUsed(filterType: String) {
        let parameters: [String: Any] = [
            "filter_type": filterType
        ]

        YMMYandexMetrica.reportEvent("filters_used", parameters: parameters)
    }

    // MARK: - User Actions
    func trackButtonTapped(buttonName: String, screenName: String) {
        let parameters: [String: Any] = [
            "button_name": buttonName,
            "screen_name": screenName
        ]

        YMMYandexMetrica.reportEvent("button_tapped", parameters: parameters)
    }

    func trackSearchPerformed(query: String, resultsCount: Int) {
        let parameters: [String: Any] = [
            "search_query": query,
            "results_count": resultsCount
        ]

        YMMYandexMetrica.reportEvent("search_performed", parameters: parameters)
    }

    // MARK: - Test Methods (для отладки)

    /// Проверяет статус аналитики
    func checkAnalyticsStatus() {
        print("📊 ===== СТАТУС АНАЛИТИКИ =====")
        print("📊 API ключ: 52b59e67-56d9-4d95-b3a9-2369994c3166")
        print("📊 Версия SDK: \(YMMYandexMetrica.libraryVersion)")
        print("📊 SDK загружен и готов к работе")
        print("📊 ===========================")
    }

    func testAnalytics() {
        print("🧪 ===== ТЕСТИРОВАНИЕ АНАЛИТИКИ =====")
        print("📊 API ключ: 52b59e67-56d9-4d95-b3a9-2369994c3166")
        print("📊 Версия SDK: \(YMMYandexMetrica.libraryVersion)")
        print("📊 SDK загружен и готов к работе")
        print("")

        print("🧪 Отправляем тестовые события...")

        trackScreenOpen(screen: "Main")
        print("✅ Отправлено событие открытия экрана Main")

        trackButtonClick(screen: "Main", item: "add_track")
        print("✅ Отправлено событие тапа на кнопку add_track")

        trackButtonClick(screen: "Main", item: "track")
        print("✅ Отправлено событие тапа на трекер")

        trackButtonClick(screen: "Main", item: "filter")
        print("✅ Отправлено событие тапа на фильтр")

        trackButtonClick(screen: "Main", item: "edit")
        print("✅ Отправлено событие редактирования")

        trackButtonClick(screen: "Main", item: "delete")
        print("✅ Отправлено событие удаления")

        trackScreenClose(screen: "Main")
        print("✅ Отправлено событие закрытия экрана Main")

        print("")
        print("🎉 Все тестовые события отправлены!")
        print("📊 Проверьте логи YandexMobileMetrica в консоли")
        print("📊 События должны появиться в личном кабинете через несколько минут")
        print("🧪 =================================")
    }
}
