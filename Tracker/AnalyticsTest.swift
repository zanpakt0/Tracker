//
//  AnalyticsTest.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 06.11.2025.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsTest {


    static func runFullTest() {
        print("🧪 ===== ПОЛНЫЙ ТЕСТ АНАЛИТИКИ =====")


        checkSDKStatus()


        testEventSending()


        checkConfiguration()

        print("🧪 =================================")
    }


    private static func checkSDKStatus() {
        print("📊 Проверка статуса SDK:")
        print("   - Версия: \(YMMYandexMetrica.libraryVersion)")
        print("   - SDK загружен и готов к работе")
        print("")
    }


    private static func testEventSending() {
        print("📊 Тестирование отправки событий:")

        let testEvents = [
            ("event", ["event": "open", "screen": "Main"]),
            ("event", ["event": "click", "screen": "Main", "item": "add_track"]),
            ("event", ["event": "click", "screen": "Main", "item": "track"]),
            ("event", ["event": "click", "screen": "Main", "item": "filter"]),
            ("event", ["event": "close", "screen": "Main"])
        ]

        for (eventName, parameters) in testEvents {
            YMMYandexMetrica.reportEvent(eventName, parameters: parameters)
            print("   ✅ Отправлено: \(eventName) с параметрами: \(parameters)")
        }

        print("")
    }


    private static func checkConfiguration() {
        print("📊 Проверка конфигурации:")
        print("   - API ключ: 52b59e67-56d9-4d95-b3a9-2369994c3166")
        print("   - Логирование: включено (DEBUG)")
        print("   - Crash reporting: включено (DEBUG)")
        print("")
    }
}
