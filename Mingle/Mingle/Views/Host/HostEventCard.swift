//
//  HostEventCard.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//

//
//  HostEventCard.swift
//  Mingle
//

import SwiftUI

struct HostEventCard: View {
    let title: String
    let date: String
    let city: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
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
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

#Preview {
    HostEventCard(
        title: "Birthday Bash",
        date: "Oct 1, 2025 - 10:30 PM",
        city: "Fullerton"
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
