//
//  HostHomeView.swift
//  Mingle
//

import SwiftUI

struct HostHomeView: View {
    @EnvironmentObject var store: AppStore
    @State private var showingNewEvent = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
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

                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    VStack(spacing: 4) {
                        Text("MINGLE")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                        
                        if let name = store.currentUser?.name {
                            Text("Welcome, \(name)")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        } else {
                            Text("Host")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Text("My Events")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.top, 4)
                    }
                    .padding(.top, 40)

                    Spacer(minLength: 20)

                    // MARK: - Event List
                    if store.eventsForCurrentUser().isEmpty {
                        VStack {
                            Spacer()
                            Text("No events yet.\nTap + to create your first!")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.8))
                                .font(.headline)
                                .padding()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(store.eventsForCurrentUser()) { event in
                                    NavigationLink(destination: HostEventDetailView(event: event)) {
                                        HostEventCard(
                                            title: event.title,
                                            date: event.date.formatted(date: .abbreviated, time: .shortened),
                                            city: event.city
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical, 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }

                // MARK: - Floating + Button
                Button(action: { showingNewEvent = true }) {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
                .sheet(isPresented: $showingNewEvent) {
                    NewEventSheet().environmentObject(store)
                }
            }
        }
    }
}

#Preview {
    HostHomeView().environmentObject(AppStore())
}
