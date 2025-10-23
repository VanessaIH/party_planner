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
import MapKit

struct NewEventSheet: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss

    /// If nil → create mode; if set → edit mode
    let editing: EventItem?

    @State private var title = ""
    @State private var date = Date()
    @State private var city = ""
    @State private var fullAddress = ""
    @State private var description = ""
    @State private var isPublic = true
    
    
    @State private var isSaving = false
    @State private var alertMessage: String?

    init(editing: EventItem? = nil) {
        self.editing = editing
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text(editing == nil ? "Create New Event" : "Edit Event")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    // Basics
                    InputField(icon: "textformat", placeholder: "Title", text: $title)
                    InputField(icon: "building.2", placeholder: "City (publicly visible)", text: $city)
                    InputField(icon: "mappin.and.ellipse", placeholder: "Full street address (shown after approval)", text: $fullAddress)
                    InputField(icon: "doc.text", placeholder: "Description (optional)", text: $description)

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

                    Text("Guests always see the city. The full street address only appears after you approve them.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    PrimaryButton(title: isSaving ? "Saving…" : (editing == nil ? "Save Event" : "Save Changes")) {
                        Task { await save() }
                    }
                    .disabled(isSaving || title.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.1, blue: 0.4),
                        Color(red: 0.7, green: 0.5, blue: 0.9)
                    ]),
                    center: .center, startRadius: 30, endRadius: 600
                )
                .ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear { preloadIfEditing() }
            .alert("Couldn't confirm address", isPresented: .constant(alertMessage != nil)) {
                Button("OK") { alertMessage = nil }
            } message: {
                Text(alertMessage ?? "")
            }
        }
    }

    // MARK: - Editing preload
    private func preloadIfEditing() {
        guard let e = editing else { return }
        title = e.title
        date = e.date
        city = e.city
        fullAddress = e.fullAddress ?? ""
        description = e.description ?? ""
        isPublic = e.isPublic
    }

    // MARK: - Save (geocodes address → lat/lon)
    private func geocodeIfPossible() async -> CLLocationCoordinate2D? {
        let addressString = [fullAddress, city]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")

        guard !addressString.isEmpty else { return nil }

        do {
            let coord = try await GeocodingService.shared.geocode(addressString)
            return coord
        } catch {
            // Optional: tell the user, but still allow saving (event will just not be distance-filterable)
            alertMessage = "We couldn't find that address. You can save the event, but distance filtering and maps may not work until the address is corrected."
                return nil
            }
        }
    
        private func save() async {
            guard !isSaving else { return }
            isSaving = true
            defer { isSaving = false }

            let coord = await geocodeIfPossible()
            let lat = coord?.latitude
            let lon = coord?.longitude

            if var e = editing {
                e.title = title
                e.date = date
                e.city = city
                e.fullAddress = fullAddress.isEmpty ? nil : fullAddress
                e.description = description.isEmpty ? nil : description
                e.isPublic = isPublic
                e.latitude = lat
                e.longitude = lon
                store.updateEvent(e)
        } else {
            store.createEvent(
                title: title,
                date: date,
                city: city,
                fullAddress: fullAddress.isEmpty ? nil : fullAddress,
                description: description.isEmpty ? nil : description,
                isPublic: isPublic,
                latitude: lat,
                longitude: lon
            )
        }

        dismiss()
    }
}

#Preview {
    NewEventSheet().environmentObject(AppStore())
}
