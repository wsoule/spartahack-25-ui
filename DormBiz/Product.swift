////
////  Product.swift
////  DormBiz
////
////  Created by Wyat Soule on 2/1/25.
////
//
//import Foundation
//import SwiftData
//
//@Model
//final class Product {
//    var name: String
//    var cost: Double
//    var desc: String
//    
//    init(name: String, cost: Double, desc: String = "") {
//        self.name = name
//        self.cost = cost
//        self.desc = desc
//    }
//}

import Foundation
import FirebaseFirestore

struct Product: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var cost: Double
    var description: String
}
