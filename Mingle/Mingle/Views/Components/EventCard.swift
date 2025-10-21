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
    var city: String
    var image: String = "party" // Add default asset in Assets.xcassets

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

            Text(date)
                .font(AppTheme.Fonts.small)
                .foregroundColor(AppTheme.Colors.textSecondary)

            Text(city)
                .font(AppTheme.Fonts.small)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Layout.cornerRadius)
        .shadow(radius: AppTheme.Layout.shadowRadius)
    }
}

#Preview {
    EventCard(title: "Beach Party", date: "Oct 5, 2025", city: "Los Angeles")
        .padding()
}
