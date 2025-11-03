//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 03.11.2025.
//

import Foundation

struct TrackerCategory: Codable {
    let title: String
    let trackers: [Tracker]

    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}
