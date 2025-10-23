//
//  EventCard.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//

//
//  EventCard.swift
//  Mingle
//

import SwiftUI

struct EventCard: View {
    var title: String
    var date: String
    var cityOrAddress: String
    var isPublic: Bool = true
    var image: String = "party" // Add default asset in Assets.xcassets
    var distanceText: String? = nil
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .cornerRadius(AppTheme.Layout.cornerRadius)

            Text(title)
                .font(AppTheme.Fonts.subtitle)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.9)

            Text(date)
                .font(AppTheme.Fonts.small)
                .foregroundColor(AppTheme.Colors.textSecondary)

            Text(isPublic ? "Public" : "Private")
                .font(.caption.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isPublic ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(8)
            
            Text(cityOrAddress)
                .font(AppTheme.Fonts.small)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .lineLimit(2)
            if let dist = distanceText {
                Text(dist)
                    .font(AppTheme.Fonts.small)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Layout.cornerRadius)
        .shadow(radius: AppTheme.Layout.shadowRadius)
    }
}

#Preview {
    VStack(spacing: 16) {
        EventCard(
            title: "Beach Party",
            date: "Oct 5, 2025 · 6 PM",
            cityOrAddress: "Los Angeles",
            distanceText: "5.4 mi"
        )

        EventCard(
            title: "Pool Bash",
            date: "Jul 10, 2025 · 8 PM",
            cityOrAddress: "123 Main St, Irvine",
            distanceText: nil
        )
    }
    .padding()
    .background(Color.black.opacity(0.1))
}
