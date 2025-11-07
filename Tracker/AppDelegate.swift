//
//  AppDelegate.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 03.11.2025.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let apiKey = "52b59e67-56d9-4d95-b3a9-2369994c3166"

        if let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) {

            #if DEBUG
            configuration.logs = true
            configuration.crashReporting = true
            #endif

            YMMYandexMetrica.activate(with: configuration)

            #if DEBUG
            print("📊 YandexMobileMetrica активирована с API ключом: \(apiKey)")
            print("📊 Версия SDK: \(YMMYandexMetrica.libraryVersion)")


            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                AnalyticsTest.runFullTest()
            }
            #endif
        } else {
            #if DEBUG
            print("❌ Ошибка инициализации YandexMobileMetrica")
            #endif
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        return CoreDataManager.shared.persistentContainer
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        CoreDataManager.shared.saveContext()
    }

}

