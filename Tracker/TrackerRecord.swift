//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Zhukov Konstantin on 03.11.2025.
//

import Foundation

struct TrackerRecord: Codable {
    let trackerId: UUID
    let date: Date

    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
}
