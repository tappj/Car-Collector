//
//  RewardsView.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/25/25.
//

import SwiftUI

struct RewardsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var achievementManager = AchievementManager.shared
    @State private var selectedCategory: AchievementCategory? = nil
    
    var filteredAchievements: [Achievement] {
        if let category = selectedCategory {
            return achievementManager.achievements.filter { $0.category == category }
        }
        return achievementManager.achievements
    }
    
    var unlockedCount: Int {
        achievementManager.achievements.filter { $0.isUnlocked }.count
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with stats
                VStack(spacing: 16) {
                    // Title and coins
                    HStack {
                        Text("Achievements")
                            .font(.system(size: 34, weight: .bold))
                        
                        Spacer()
                        
                        HStack(spacing: 6) {
                            Image(systemName: "centsign.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                            
                            Text("\(achievementManager.totalCoins)")
                                .font(.system(size: 22, weight: .bold))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                    
                    // Progress
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(unlockedCount)/\(achievementManager.achievements.count) Unlocked")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(Int((Double(unlockedCount) / Double(achievementManager.achievements.count)) * 100))%")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 6)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black)
                                    .frame(width: geometry.size.width * CGFloat(unlockedCount) / CGFloat(achievementManager.achievements.count), height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                }
                .padding(24)
                .background(Color.white)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryChip(
                            title: "All",
                            count: achievementManager.achievements.count,
                            isSelected: selectedCategory == nil,
                            action: { selectedCategory = nil }
                        )
                        
                        CategoryChip(
                            title: "Collection",
                            count: achievementManager.achievements.filter { $0.category == .collection }.count,
                            isSelected: selectedCategory == .collection,
                            action: { selectedCategory = .collection }
                        )
                        
                        CategoryChip(
                            title: "Rarity",
                            count: achievementManager.achievements.filter { $0.category == .rarity }.count,
                            isSelected: selectedCategory == .rarity,
                            action: { selectedCategory = .rarity }
                        )
                        
                        CategoryChip(
                            title: "Points",
                            count: achievementManager.achievements.filter { $0.category == .points }.count,
                            isSelected: selectedCategory == .points,
                            action: { selectedCategory = .points }
                        )
                        
                        CategoryChip(
                            title: "Level",
                            count: achievementManager.achievements.filter { $0.category == .level }.count,
                            isSelected: selectedCategory == .level,
                            action: { selectedCategory = .level }
                        )
                        
                        CategoryChip(
                            title: "Specific",
                            count: achievementManager.achievements.filter { $0.category == .specific }.count,
                            isSelected: selectedCategory == .specific,
                            action: { selectedCategory = .specific }
                        )
                        
                        CategoryChip(
                            title: "Dedication",
                            count: achievementManager.achievements.filter { $0.category == .dedication }.count,
                            isSelected: selectedCategory == .dedication,
                            action: { selectedCategory = .dedication }
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                }
                .background(Color.white)
                
                // Achievements List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredAchievements) { achievement in
                            AchievementCard(achievement: achievement)
                        }
                    }
                    .padding(24)
                }
                .background(Color(.systemGray6).opacity(0.3))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        achievementManager.hasNewAchievements = false
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                
                Text("\(count)")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(isSelected ? Color.white.opacity(0.3) : Color.black.opacity(0.1))
                    )
            }
            .foregroundColor(isSelected ? .white : .black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color(.systemGray6))
            )
        }
    }
}

// MARK: - Achievement Card
struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.black : Color(.systemGray5))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: 26))
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                
                Text(achievement.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "centsign.circle.fill")
                            .font(.system(size: 14))
                        Text("\(achievement.coinReward)")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(achievement.isUnlocked ? .black : .secondary)
                    
                    if achievement.isUnlocked, let date = achievement.unlockedDate {
                        Text("• \(formatDate(date))")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    } else {
                        Text("• Locked")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 4)
            }
            
            Spacer()
            
            // Checkmark or lock
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(achievement.isUnlocked ? 0.08 : 0.04), radius: achievement.isUnlocked ? 8 : 4)
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    RewardsView()
}
