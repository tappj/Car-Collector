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
            VStack(spacing: 0) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Car Collector")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Discover and collect rare vehicles")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Quick Stats Card (Optional - shows collection overview)
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        // Total Cars
                        VStack(spacing: 4) {
                            Text("0")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Cars")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 40)
                        
                        // Total Points
                        VStack(spacing: 4) {
                            Text("0")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Points")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 40)
                        
                        // Rarest
                        VStack(spacing: 4) {
                            Text("—")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Rarest")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Main Action Buttons
                VStack(spacing: 16) {
                    // Scan Car Button
                    Button(action: {
                        showCamera = true
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Scan New Car")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.black)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                    
                    // Rewards Button
                    Button(action: {
                        // Will navigate to rewards later
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("View Rewards")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color(.systemGray4), lineWidth: 1.5)
                                )
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
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
