//
//  GeocodingService.swift
//  Mingle
//
//  Created by Vanessa Iwaki on 10/21/25.
//

import Foundation
import MapKit

enum GeocodingError: Error { case notFound }

final class GeocodingService {
    static let shared = GeocodingService()
    private init(){}

    /// Geocode a human-readable address string into a coordinate.
    func geocode(_ address: String) async throws -> CLLocationCoordinate2D {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        guard let item = response.mapItems.first else {
            throw GeocodingError.notFound
        }

        let coordinate = item.location.coordinate 
            return coordinate
    }
}
