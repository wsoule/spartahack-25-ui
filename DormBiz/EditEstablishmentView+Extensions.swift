//
//  EditSessionView+Extensions.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//
import SwiftUI
import CoreLocation

extension EditEstablishmentView {
    
    // MARK: - Delete Hour Methods
    func deleteHour(_ hour: Hour) {
        if let index = establishment.hours.firstIndex(where: { $0.id == hour.id }) {
            establishment.hours.remove(at: index)
        }
    }

    func deleteHours(at offsets: IndexSet) {
        establishment.hours.remove(atOffsets: offsets)
    }

    // MARK: - Remove Tag
    func removeTag(_ tag: String) {
        establishment.tags.removeAll { $0 == tag }
    }


}
