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
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            CollectionView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "car.fill" : "car")
                    Text("Collection")
                }
                .tag(1)
            
            ShowcaseView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "star.fill" : "star")
                    Text("Showcase")
                }
                .tag(2)
            
            RaceView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "flag.checkered.2.crossed" : "flag.checkered.2.crossed")
                    Text("Race")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.black)
        .onAppear {
            // Modern tab bar styling
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            // Subtle shadow
            appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToCollectionTab"))) { _ in
            selectedTab = 1
        }
    }
}

#Preview {
    MainTabView()
}
