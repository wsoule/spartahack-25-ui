//
//  LocationSection.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI
import CoreLocation

struct LocationSection: View {
    @Binding var establishment: Establishment
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        Section(header: Text("Location")) {
            HStack {
                Text("Lat: \(establishment.location.latitude, specifier: "%.4f")")
                Text("Long: \(establishment.location.longitude, specifier: "%.4f")")
                Spacer()
                Button("Here") {
                    updateLocation()
                }
                .disabled(locationManager.userLocation == nil) // Disable if location isn't available
            }
        }
    }

    private func updateLocation() {
        if let userCoordinates = locationManager.userLocation {
            establishment.location = Location(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
        }
    }
}
