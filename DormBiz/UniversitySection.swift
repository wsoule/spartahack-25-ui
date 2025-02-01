//
//  UniversitySection.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//
import SwiftUI

struct UniversitySection: View {
    @Binding var selectedUniversity: String

    var body: some View {
        Section(header: Text("University")) {
            Picker("Select University", selection: $selectedUniversity) {
                Text("MSU").tag("MSU")
                Text("UofM").tag("UofM")
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}
