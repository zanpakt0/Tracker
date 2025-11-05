//
//  CoreDataExtensions.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 05.11.2025.
//

import CoreData
import Foundation

// MARK: - TrackerCoreData Extensions
extension TrackerCoreData {
    func toTracker() -> Tracker {
        let scheduleArray = (self.schedule as? [Int]) ?? []
        return Tracker(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            color: self.color ?? "Green",
            emoji: self.emoji ?? "😪",
            schedule: scheduleArray
        )
    }

    static func fromTracker(_ tracker: Tracker, context: NSManagedObjectContext) -> TrackerCoreData {
        let coreDataTracker = TrackerCoreData(context: context)
        coreDataTracker.id = tracker.id
        coreDataTracker.name = tracker.name
        coreDataTracker.color = tracker.color
        coreDataTracker.emoji = tracker.emoji
        coreDataTracker.schedule = tracker.schedule as NSArray
        return coreDataTracker
    }
}

// MARK: - TrackerCategoryCoreData Extensions
extension TrackerCategoryCoreData {
    func toTrackerCategory() -> TrackerCategory {
        let trackers = (self.trackers?.allObjects as? [TrackerCoreData])?.map { $0.toTracker() } ?? []
        return TrackerCategory(title: self.title ?? "", trackers: trackers)
    }

    static func fromTrackerCategory(_ category: TrackerCategory, context: NSManagedObjectContext) -> TrackerCategoryCoreData {
        let coreDataCategory = TrackerCategoryCoreData(context: context)
        coreDataCategory.title = category.title

        // Convert trackers
        let coreDataTrackers = category.trackers.map { TrackerCoreData.fromTracker($0, context: context) }
        coreDataCategory.trackers = NSSet(array: coreDataTrackers)

        return coreDataCategory
    }
}

// MARK: - TrackerRecordCoreData Extensions
extension TrackerRecordCoreData {
    func toTrackerRecord() -> TrackerRecord {
        return TrackerRecord(
            trackerId: self.trackerId ?? UUID(),
            date: self.date ?? Date()
        )
    }

    static func fromTrackerRecord(_ record: TrackerRecord, context: NSManagedObjectContext) -> TrackerRecordCoreData {
        let coreDataRecord = TrackerRecordCoreData(context: context)
        coreDataRecord.trackerId = record.trackerId
        coreDataRecord.date = record.date
        return coreDataRecord
    }
}
