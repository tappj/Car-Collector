//
//  SettingsView.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/16/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Text("Settings Coming Soon!")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SettingsView()
}
