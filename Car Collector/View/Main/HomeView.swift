//
//  HomeView.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/16/25.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @State private var showCamera = false
    @State private var cars: [Car] = []
    @State private var totalPoints: Int = 0
    @State private var totalCars: Int = 0
    
    // Leveling system computed properties
    var currentLevel: Int {
        calculateLevel(from: totalPoints)
    }
    
    var pointsForCurrentLevel: Int {
        pointsRequiredForLevel(currentLevel)
    }
    
    var pointsForNextLevel: Int {
        pointsRequiredForLevel(currentLevel + 1)
    }
    
    var progressToNextLevel: CGFloat {
        if currentLevel >= 100 { return 1.0 }
        let pointsInCurrentLevel = totalPoints - pointsForCurrentLevel
        let pointsNeededForNext = pointsForNextLevel - pointsForCurrentLevel
        return CGFloat(pointsInCurrentLevel) / CGFloat(pointsNeededForNext)
    }
    
    var pointsUntilNextLevel: Int {
        pointsForNextLevel - totalPoints
    }
    
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
                
                // Level Progress Bar (MOVED ABOVE STATS)
                if currentLevel < 100 {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Level \(currentLevel)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("\(pointsUntilNextLevel) pts to Level \(currentLevel + 1)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 8)
                                
                                // Progress
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                    .frame(width: geometry.size.width * progressToNextLevel, height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                } else {
                    VStack(spacing: 8) {
                        Text("🏆 MAX LEVEL 🏆")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                        Text("You've reached the highest level!")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
                
                // Quick Stats Card
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        // Total Cars
                        VStack(spacing: 4) {
                            Text("\(totalCars)")
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
                            Text("\(totalPoints)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Points")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 40)
                        
                        // Level
                        VStack(spacing: 4) {
                            Text("\(currentLevel)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Level")
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
                    // Scan Car Button (BIGGER)
                    Button(action: {
                        showCamera = true
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Scan New Car")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 28)
                        .padding(.vertical, 22)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                    }
                    
                    // Rewards Button (smaller)
                    Button(action: {
                        // Will navigate to rewards later
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("View Rewards")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
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
            .onAppear {
                loadCarData()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToCollectionTab"))) { _ in
                loadCarData()
            }
        }
    }
    
    // MARK: - Data Loading
    func loadCarData() {
        let db = Firestore.firestore()
        
        db.collection("cars")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error loading cars: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("⚠️ No documents found")
                    return
                }
                
                cars = documents.compactMap { document in
                    try? document.data(as: Car.self)
                }
                
                totalCars = cars.count
                totalPoints = cars.reduce(0) { $0 + $1.points }
                
                print("✅ Loaded \(totalCars) cars with \(totalPoints) total points - Level \(currentLevel)")
            }
    }
    
    // MARK: - Leveling System
    
    // Exponential leveling: starts easy, gets progressively harder
    // Level 1->2: 10 points
    // Level 2->3: 15 points
    // Level 3->4: 23 points
    // Grows exponentially to level 100
    func pointsRequiredForLevel(_ level: Int) -> Int {
        if level <= 1 { return 0 }
        
        var totalPoints = 0
        for lvl in 2...level {
            // Exponential formula: basePoints * (1.15^(level-2))
            let pointsForThisLevel = Int(Double(10) * pow(1.15, Double(lvl - 2)))
            totalPoints += pointsForThisLevel
        }
        
        return totalPoints
    }
    
    func calculateLevel(from points: Int) -> Int {
        if points == 0 { return 1 }
        
        for level in 1...100 {
            let requiredPoints = pointsRequiredForLevel(level + 1)
            if points < requiredPoints {
                return level
            }
        }
        
        return 100 // Max level
    }
}

#Preview {
    HomeView()
}
