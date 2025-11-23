//
//  MainTabView.swift
//  Car Collector
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            CollectionView()
                .tabItem {
                    Image(systemName: "car.fill")
                    Text("Collection")
                }
                .tag(1)
            
            ShowcaseView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Showcase")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.blue)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToCollectionTab"))) { _ in
            selectedTab = 1
        }
    }
}

#Preview {
    MainTabView()
}
