//
//  GuestEventCard.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//

//
//  GuestEventCard.swift
//  Mingle
//

import SwiftUI

struct GuestEventCard: View {
    let title: String
    let date: String
    let city: String
    let isPublic: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(date)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                Text(city)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
            Spacer()
            Text(isPublic ? "Public" : "Private")
                .font(.caption2.bold())
                .padding(6)
                .background(isPublic ? Color.green.opacity(0.7) : Color.red.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

#Preview {
    GuestEventCard(
        title: "Halloween Bash",
        date: "Oct 31, 2025",
        city: "Fullerton",
        isPublic: true
    )
    .padding()
    .background(
        RadialGradient(
            gradient: Gradient(colors: [
                Color(red: 0.2, green: 0.1, blue: 0.4),
                Color(red: 0.7, green: 0.5, blue: 0.9)
            ]),
            center: .center,
            startRadius: 30,
            endRadius: 400
        )
        .ignoresSafeArea()
    )
}
