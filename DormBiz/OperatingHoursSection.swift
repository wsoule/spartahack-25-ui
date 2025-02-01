//
//  OperatingHoursSection.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//
import SwiftUI

struct OperatingHoursSection: View {
    @Binding var establishment: Establishment
    @Binding var showingTimePopup: Bool
    var deleteHour: (Hour) -> Void
    var deleteHours: (IndexSet) -> Void

    var body: some View {
        Section(header: Text("Operating Hours")) {
            Button("Add Time") {
                showingTimePopup = true
            }

            if establishment.hours.isEmpty {
                Text("No hours added")
                    .foregroundColor(.gray)
                    .font(.caption)
            } else {
                List {
                    ForEach(establishment.hours) { hour in
                        HStack {
                            Text("\(hour.day.rawValue): \(hour.openTime) - \(hour.closeTime)")
                                .font(.caption)
                            Spacer()
                            Button(action: {
                                deleteHour(hour) // Call the passed delete function
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onDelete(perform: deleteHours) // Pass the deleteHours function
                }
            }
        }
    }
}
