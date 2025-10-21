////
////  NewEventSheet.swift
////  Mingle
////
////  Created by ROSZHAN RAJ on 01/10/25.
////
//
//import SwiftUI
//
//struct NewEventSheet: View {
//    @EnvironmentObject var store: AppStore
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var title = ""
//    @State private var date = Date()
//    @State private var city = ""
//    @State private var description = ""
//    @State private var isPublic = true
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 20) {
//                    
//                    InputField(icon: "textformat", placeholder: "Title", text: $title)
//                    InputField(icon: "building.2", placeholder: "City", text: $city)
//                    InputField(icon: "doc.text", placeholder: "Description", text: $description)
//                    
//                    DatePicker("Event Date & Time", selection: $date)
//                        .datePickerStyle(.compact)
//                        .padding()
//                        .background(AppTheme.Colors.cardBackground)
//                        .cornerRadius(AppTheme.Layout.cornerRadius)
//                        .shadow(radius: 2)
//                    
//                    Toggle("Public Event", isOn: $isPublic)
//                        .padding()
//                        .background(AppTheme.Colors.cardBackground)
//                        .cornerRadius(AppTheme.Layout.cornerRadius)
//                        .shadow(radius: 2)
//                    
//                    PrimaryButton(title: "Save Event") {
//                        store.createEvent(
//                            title: title,
//                            date: date,
//                            city: city,
//                            description: description,
//                            isPublic: isPublic
//                        )
//                        dismiss()
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("New Event")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") { dismiss() }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    NewEventSheet().environmentObject(AppStore())
//}
//
//  NewEventSheet.swift
//  Mingle
//

import SwiftUI

struct NewEventSheet: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var date = Date()
    @State private var city = ""
    @State private var description = ""
    @State private var isPublic = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Create New Event")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    InputField(icon: "textformat", placeholder: "Title", text: $title)
                    InputField(icon: "building.2", placeholder: "City", text: $city)
                    InputField(icon: "doc.text", placeholder: "Description", text: $description)
                    
                    DatePicker("Event Date & Time", selection: $date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .foregroundColor(.white)
                    
                    Toggle("Public Event", isOn: $isPublic)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .foregroundColor(.white)
                    
                    PrimaryButton(title: "Save Event") {
                        store.createEvent(
                            title: title,
                            date: date,
                            city: city,
                            description: description,
                            isPublic: isPublic
                        )
                        dismiss()
                    }
                }
                .padding()
            }
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.1, blue: 0.4),
                        Color(red: 0.7, green: 0.5, blue: 0.9)
                    ]),
                    center: .center,
                    startRadius: 30,
                    endRadius: 600
                )
                .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    NewEventSheet().environmentObject(AppStore())
}
