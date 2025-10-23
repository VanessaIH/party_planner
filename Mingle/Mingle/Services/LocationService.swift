//
//  LocationService.swift
//  Mingle
//
//  Created by Vanessa Iwaki on 10/21/25.
//

import CoreLocation
import Combine

final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var authorization: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func request() {
        if CLLocationManager.locationServicesEnabled() {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
    }

    // MARK: - Delegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorization = manager.authorizationStatus
        if authorization == .authorizedWhenInUse || authorization == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinate = locations.last?.coordinate
    }
}
