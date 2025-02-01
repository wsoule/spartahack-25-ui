//
//  TimeSelectionView.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI

struct TimeSelectionView: View {
    @Binding var openTime: Date
    @Binding var closeTime: Date

    var body: some View {
        HStack {
            VStack {
                Text("Open Time")
                DatePicker("", selection: $openTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            Spacer()
            VStack {
                Text("Close Time")
                DatePicker("", selection: $closeTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
        }
        .padding()
    }
}
