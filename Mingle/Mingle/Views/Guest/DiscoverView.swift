//
//  DiscoverView.swift
//  Mingle
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var store: AppStore
    
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
                
                VStack(spacing: 20) {
                    
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
                    
                    Spacer(minLength: 10)
                    
                    // MARK: - Event List
                    if store.events.isEmpty {
                        Spacer()
                        Text("No events available.\nCheck back later or host your own!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.8))
                            .font(.headline)
                            .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 14) {
                                ForEach(store.events) { event in
                                    NavigationLink(destination: GuestEventDetailView(event: event)) {
                                        GuestEventCard(
                                            title: event.title,
                                            date: event.date.formatted(date: .abbreviated, time: .shortened),
                                            city: event.city,
                                            isPublic: event.isPublic
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    DiscoverView().environmentObject(AppStore())
}
