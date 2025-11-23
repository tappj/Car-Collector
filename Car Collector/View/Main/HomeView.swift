//
//  HomeView.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/16/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showCamera = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // App Title
                Text("Car Collector")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Spacer()
                
                // Main Action Buttons
                VStack(spacing: 20) {
                    // Scan Car Button (Large, primary action)
                    Button(action: {
                        showCamera = true
                    }) {
                        VStack(spacing: 15) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            
                            Text("Scan Car")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                    }
                    
                    // Rewards Button
                    Button(action: {
                        // Will navigate to rewards later
                    }) {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .frame(width: 60)
                            
                            Text("Rewards")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showCamera) {
                CustomCameraView()
            }
        }
    }
}

#Preview {
    HomeView()
}
