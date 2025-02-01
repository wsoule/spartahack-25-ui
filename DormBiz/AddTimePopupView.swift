//
//  AddTimePopupView.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI

struct AddTimePopupView: View {
    @Binding var isPresented: Bool
    @Binding var establishment: Establishment
    
    @State private var openTime = Date()
    @State private var closeTime = Date()
    @State private var selectedDays: Set<DayOfWeek> = []
    
    private var diffTime: String {
        let interval = closeTime.timeIntervalSince(openTime)
        if interval < 0 {
            return "Invalid Time Selection"
        }
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours) hrs \(minutes) mins"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select Time and Days")
                    .font(.headline)
                
                TimeSelectionView(openTime: $openTime, closeTime: $closeTime)
                Text("Open Duration: \(diffTime)").font(.subheadline).foregroundColor(.blue)
                
                DaySelectionView(selectedDays: $selectedDays)
                
                Button("Add Time") {
                    for day in selectedDays {
                        let newHour = Hour(day: day, openTime: formatTime(openTime), closeTime: formatTime(closeTime))
                        establishment.hours.append(newHour)
                    }
                    isPresented = false
                }
                .padding()
                
                Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(.red)
                .padding()
            }
            .padding()
        }
    }
    private func formatTime(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
}
