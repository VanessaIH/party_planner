//
//  InputField.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//

//
//  InputField.swift
//  Mingle
//

import SwiftUI

struct InputField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.secondary)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(AppTheme.Fonts.body)
            } else {
                TextField(placeholder, text: $text)
                    .font(AppTheme.Fonts.body)
            }
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Layout.cornerRadius)
        .shadow(radius: 2)
    }
}

#Preview {
    VStack(spacing: 16) {
        InputField(icon: "envelope", placeholder: "Email", text: .constant(""))
        InputField(icon: "lock", placeholder: "Password", text: .constant(""), isSecure: true)
    }
    .padding()
}
