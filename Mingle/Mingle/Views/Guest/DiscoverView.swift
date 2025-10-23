import SwiftUI
import CoreLocation

struct DiscoverView: View {
    @EnvironmentObject var store: AppStore
    @StateObject private var loc = LocationService()


    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background
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

                VStack(spacing: 16) {

                    // MARK: - Header
                    VStack(spacing: 4) {
                        Text("MINGLE")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 4)

                        Text("Discover Events 🎉")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.top, 2)
                    }
                    .padding(.top, 40)

                    // MARK: - Search
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                        TextField("Search party / host / location", text: $store.searchText)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        if !store.searchText.isEmpty {
                            Button(action: {
                                store.searchText = ""
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(.secondary)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                    // MARK: - Distance slider
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Maximum distance")
                            Spacer()
                            Text("\(Int(store.maxDistance)) mi")
                                .monospacedDigit()
                                .foregroundStyle(.primary)
                        }
                        Slider(value: $store.maxDistance, in: 0...20, step: 1)

                        if store.userCoordinates == nil {
                            Text("Enable location to filter by distance.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Event List
                    if store.filteredEvents().isEmpty {
                        Spacer()
                        Text("No matching events.\nTry widening your distance or clearing search.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.85))
                            .font(.headline)
                            .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 14) {
                                ForEach(store.filteredEvents()) { event in
                                    NavigationLink {
                                        GuestEventDetailView(event: event)
                                    } label: {
                                        GuestEventCard(
                                            title: event.title,
                                            date: event.date.formatted(date: .abbreviated, time: .shortened),
                                
                                            // city shown until approved; full address if approved
                                            cityOrAddress: event.displayAddress(
                                                forUserIdString: store.currentUser?.email,
                                                userUUID: store.currentUser?.id
                                            ),
                                            isPublic: event.isPublic,
                                            //distanceText: distanceString(for: event)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                    }

                    Spacer(minLength: 8)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear { loc.request() }
        .onReceive(loc.$coordinate) { coord in
            store.userCoordinates = coord
        }
    }

    private func distanceString(for event: EventItem) -> String? {
        guard let d = event.distanceMiles(from: store.userCoordinates) else { return nil }
        return String(format: "%.1f mi", d)
    }
}

#Preview {
    DiscoverView().environmentObject(AppStore())
}
