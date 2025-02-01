//
//  DaySelectionView.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//
import SwiftUI

struct DaySelectionView: View {
    @Binding var selectedDays: Set<DayOfWeek>

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Days")
                .font(.subheadline)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(DayOfWeek.allCases, id: \.self) { day in
                    Button(action: {
                        toggleDaySelection(day)
                    }) {
                        Text(day.rawValue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
    }

    private func toggleDaySelection(_ day: DayOfWeek) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
}
