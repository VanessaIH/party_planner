//
//  PrimaryButton.swift
//  Mingle
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Fonts.subtitle)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppTheme.Colors.primary, AppTheme.Colors.secondary]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(AppTheme.Layout.cornerRadius)
                .shadow(color: AppTheme.Colors.primary.opacity(0.5),
                        radius: AppTheme.Layout.shadowRadius,
                        x: 0, y: 3)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Join Party") {}
        PrimaryButton(title: "Create Event") {}
        PrimaryButton(title: "Submit RSVP") {}
    }
    .padding()
    .background(Color.black.opacity(0.1))
}
