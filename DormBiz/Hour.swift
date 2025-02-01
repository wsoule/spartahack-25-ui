//
//  Hour.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import Foundation
import SwiftData

@Model
final class Hour {
    var day: String  // Example: "Monday", "Tuesday", etc.
    var openTime: String  // Example: "08:00 AM"
    var closeTime: String  // Example: "10:00 PM"
    var establishment: Establishment?  // Relationship back to Establishment

    init(day: String, openTime: String, closeTime: String, establishment: Establishment? = nil) {
        self.day = day
        self.openTime = openTime
        self.closeTime = closeTime
        self.establishment = establishment
    }
}
