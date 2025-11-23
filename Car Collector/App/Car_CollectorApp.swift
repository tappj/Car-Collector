//
//  Car_CollectorApp.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/15/25.
//

import SwiftUI
import FirebaseCore

@main
struct Car_CollectorApp: App {
    
    init() {
        FirebaseApp.configure()
        print("🔥 Firebase configured successfully")
        print("🔥 Project ID: car-collector-7b62c")
        print("🔥 Storage Bucket: car-collector-7b62c.firebasestorage.app")
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()  // Changed from ContentView() to SplashScreenView()
        }
    }
}
