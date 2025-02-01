//
//  EstablishmentView.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//
import SwiftUI
import SwiftData

struct EstablishmentView: View {
    @Query(sort: \Establishment.name) private var establishments: [Establishment]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            ForEach(establishments) { establishment in
                NavigationLink(value: establishment) {
                    HStack {
                        // Left Side: Name, Description, and Tags
                        VStack(alignment: .leading, spacing: 5) {
                            Text(establishment.name)
                                .font(.headline)
                            
                            Text(establishment.desc)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // Tags as a horizontally scrollable bar
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(establishment.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue.opacity(0.2))
                                            .foregroundColor(.blue)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Right Side: Hours
                        VStack(alignment: .trailing) {
                            ForEach(establishment.hours) { hour in
                                Text("\(hour.day.rawValue): \(hour.openTime) - \(hour.closeTime)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
    }
}

#Preview {
    EstablishmentView()
}
