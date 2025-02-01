//
//  Item.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
