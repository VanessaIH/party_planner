//
//  HostGateView.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//

import SwiftUI

struct HostGateView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        if store.currentUserID == nil {
            AuthView()
        } else {
            HostHomeView()
        }
    }
}

#Preview {
    HostGateView().environmentObject(AppStore())
}
