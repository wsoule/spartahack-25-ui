//
//  TagSection.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI

struct TagsSection: View {
    @Binding var establishment: Establishment
    @Binding var newTag: String
    var removeTag: (String) -> Void // Closure to handle tag removal

    var body: some View {
        Section(header: Text("Tags")) {
            HStack {
                TextField("Add tag", text: $newTag)
                Button("Add") {
                    if !newTag.isEmpty {
                        establishment.tags.append(newTag)
                        newTag = ""
                    }
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(establishment.tags, id: \.self) { tag in
                        HStack {
                            Text(tag)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Button(action: {
                                removeTag(tag) // Call the passed removeTag function
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

