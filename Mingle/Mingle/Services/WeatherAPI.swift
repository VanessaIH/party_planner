//
//  WeatherAPI.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 02/10/25.
//

import Foundation

// MARK: - Response Models
struct WeatherResponse: Decodable {
    let daily: Daily
    
    struct Daily: Decodable {
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
    }
}

// MARK: - Weather API Service
enum WeatherAPI {
    
    static func fetchWeather(latitude: Double, longitude: Double) async -> String? {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,temperature_2m_min&timezone=auto"
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
            
            // grab first day’s high/low
            let high = Int(response.daily.temperature_2m_max.first ?? 0)
            let low = Int(response.daily.temperature_2m_min.first ?? 0)
            
            return "\(high)° / \(low)°"
        } catch {
            print("❌ WeatherAPI error:", error)
            return nil
        }
    }
}
