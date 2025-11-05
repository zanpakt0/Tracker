//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 04.11.2025.
//

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Handle Core Data migration errors
                if error.code == 134140 {
                    // Delete the store and recreate it
                    self.deletePersistentStore()
                    // Try to load again
                    container.loadPersistentStores { _, secondError in
                        if let secondError = secondError as NSError? {
                            assertionFailure("Unresolved error after store deletion: \(secondError), \(secondError.userInfo)")
                        }
                    }
                } else {
                    assertionFailure("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
        return container
    }()

    private func deletePersistentStore() {
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else { return }

        do {
            try FileManager.default.removeItem(at: storeURL)
            print("Successfully deleted persistent store at: \(storeURL)")
        } catch {
            print("Error deleting persistent store: \(error)")
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Tracker Operations
    func createTracker(name: String, color: String, emoji: String, schedule: [Int], categoryTitle: String) -> TrackerCoreData {
        let tracker = TrackerCoreData(context: context)
        tracker.id = UUID()
        tracker.name = name
        tracker.color = color
        tracker.emoji = emoji
        tracker.schedule = schedule as NSArray

        let category = getOrCreateCategory(title: categoryTitle)
        tracker.category = category

        saveContext()
        return tracker
    }

    func fetchTrackers() -> [TrackerCoreData] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching trackers: \(error)")
            return []
        }
    }

    func deleteTracker(_ tracker: TrackerCoreData) {
        context.delete(tracker)
        saveContext()
    }

    // MARK: - Category Operations
    func getOrCreateCategory(title: String) -> TrackerCategoryCoreData {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)

        do {
            let categories = try context.fetch(request)
            if let existingCategory = categories.first {
                return existingCategory
            }
        } catch {
            print("Error fetching category: \(error)")
        }

        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        saveContext()
        return category
    }

    func fetchCategories() -> [TrackerCategoryCoreData] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }

    // MARK: - Record Operations
    func createRecord(trackerId: UUID, date: Date) -> TrackerRecordCoreData {
        let record = TrackerRecordCoreData(context: context)
        record.trackerId = trackerId
        record.date = date

        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)

        do {
            let trackers = try context.fetch(request)
            if let tracker = trackers.first {
                record.tracker = tracker
            }
        } catch {
            print("Error finding tracker for record: \(error)")
        }

        saveContext()
        return record
    }

    func fetchRecords(for trackerId: UUID? = nil) -> [TrackerRecordCoreData] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()

        if let trackerId = trackerId {
            request.predicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)
        }

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching records: \(error)")
            return []
        }
    }

    func deleteRecord(_ record: TrackerRecordCoreData) {
        context.delete(record)
        saveContext()
    }

    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId == %@ AND date >= %@ AND date < %@",
                                      trackerId as CVarArg,
                                      Calendar.current.startOfDay(for: date) as CVarArg,
                                      Calendar.current.startOfDay(for: date.addingTimeInterval(86400)) as CVarArg)

        do {
            let records = try context.fetch(request)
            return !records.isEmpty
        } catch {
            print("Error checking completion: \(error)")
            return false
        }
    }

    func toggleTrackerCompletion(trackerId: UUID, date: Date) {
        if isTrackerCompleted(trackerId: trackerId, date: date) {
            // Remove record
            let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "trackerId == %@ AND date >= %@ AND date < %@",
                                          trackerId as CVarArg,
                                          Calendar.current.startOfDay(for: date) as CVarArg,
                                          Calendar.current.startOfDay(for: date.addingTimeInterval(86400)) as CVarArg)

            do {
                let records = try context.fetch(request)
                for record in records {
                    context.delete(record)
                }
            } catch {
                print("Error removing record: \(error)")
            }
        } else {

            _ = createRecord(trackerId: trackerId, date: date)
        }

        saveContext()
    }
}
