//
//  MapView.swift
//  DormBiz
//
//  Created by Wyat Soule on 2/1/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), // Example: London coordinates
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

        let places = [
            Place(name: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)),
            // Add more places as needed
        ]

        var body: some View {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: places) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    PlaceAnnotationView(title: place.name)
                }
            }
             .onAppear {
                 locationManager.requestLocation()
             }
            .frame()
        }
}


struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct PlaceAnnotationView: View {
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.callout)
                .padding(5)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)

            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)

            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.red)
                .offset(y: -5)
        }
    }
}



#Preview {
    MapView()
}
