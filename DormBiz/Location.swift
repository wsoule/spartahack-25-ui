//
//  Location.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import Foundation
import SwiftData

@Model
final class Location {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
