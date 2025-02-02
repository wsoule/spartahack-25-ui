//
//  DetailsSection.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI

struct DetailsSection: View {
    @Binding var establishment: Establishment
    @Binding var selectedType: TypeEstablishment

    var body: some View {
        Section(header: Text("Details")) {
            TextField("Name", text: $establishment.name)
            TextField("Description", text: $establishment.desc)
            Picker("Type", selection: $selectedType) {
                ForEach(TypeEstablishment.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
        }
    }
}
