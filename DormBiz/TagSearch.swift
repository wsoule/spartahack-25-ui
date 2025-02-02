//
//  TagSearch.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI

struct TagSearch: View {
    @State var newTag: String = ""
    @State var tags: [String] = []


    var body: some View {
        VStack(alignment: .leading) {
            // Input field and add button
            HStack {
                TextField("Search by tag", text: $newTag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button("Add") {
                    addTag()
                }
                .disabled(newTag.isEmpty)
            }
            .padding()
            
            // Display tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        HStack {
                            Text(tag)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Button(action: {
                                removeTag(tag)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTag.isEmpty, !tags.contains(trimmedTag) else { return }
        tags.append(trimmedTag)
        newTag = ""
    }

    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
}

#Preview {
    TagSearch(tags: ["hello"])
}
