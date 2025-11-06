//
//  CreateHabitViewControllerDelegate.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 03.11.2025.
//

import Foundation

protocol CreateHabitViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, category: TrackerCategory)
}
