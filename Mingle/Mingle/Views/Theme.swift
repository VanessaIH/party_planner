//
//  Theme.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//

//
//  Theme.swift
//  Mingle
//
//  Created by Roszhan Raj on 01/10/25.
//

import SwiftUI

struct AppTheme {
    // MARK: - Colors
    struct Colors {
        static let primary = Color("PrimaryColor")     // Add to Assets (e.g. pink/red)
        static let secondary = Color("SecondaryColor") // Add to Assets (e.g. teal/blue)
        static let background = Color(.systemBackground)
        static let cardBackground = Color(.secondarySystemBackground)
        static let textPrimary = Color.primary
        static let textSecondary = Color.gray
    }

    // MARK: - Fonts
    struct Fonts {
        static let title = Font.system(size: 28, weight: .bold)
        static let subtitle = Font.system(size: 20, weight: .semibold)
        static let body = Font.system(size: 16, weight: .regular)
        static let small = Font.system(size: 14, weight: .regular)
    }

    // MARK: - Layout
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
        static let shadowRadius: CGFloat = 6
    }
}
