//
//  User.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import Foundation
import SwiftData

@Model
final class User {
    var name: String
    var phoneNumber: String
    var email: String
    var establishments: [Establishment]?
    
    init(name: String, phoneNumber: String, email: String, establishments: [Establishment] = []){
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.establishments = establishments
    }
}
