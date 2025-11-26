//
//  Achievement.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/25/25.
//

import Foundation
import FirebaseFirestore
import Combine

enum AchievementCategory: String, Codable {
    case collection = "Collection"
    case rarity = "Rarity"
    case points = "Points"
    case level = "Level"
    case specific = "Specific"
    case dedication = "Dedication"
}

struct Achievement: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var category: AchievementCategory
    var coinReward: Int
    var requirement: Int
    var iconName: String
    var isUnlocked: Bool = false
    var unlockedDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, category, coinReward, requirement, iconName, isUnlocked, unlockedDate
    }
}

// MARK: - Achievement Definitions
class AchievementManager: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var unlockedAchievements: [String] = []
    @Published var totalCoins: Int = 0
    @Published var hasNewAchievements: Bool = false
    
    static let shared = AchievementManager()
    
    init() {
        loadAchievements()
        loadUserProgress()
    }
    
    // MARK: - All Achievements (100 total)
    func loadAchievements() {
        achievements = [
            // COLLECTION ACHIEVEMENTS (20)
            Achievement(id: "first_car", title: "First Wheels", description: "Collect your first car", category: .collection, coinReward: 10, requirement: 1, iconName: "car.fill"),
            Achievement(id: "5_cars", title: "Small Garage", description: "Collect 5 cars", category: .collection, coinReward: 25, requirement: 5, iconName: "car.2.fill"),
            Achievement(id: "10_cars", title: "Car Enthusiast", description: "Collect 10 cars", category: .collection, coinReward: 50, requirement: 10, iconName: "car.circle"),
            Achievement(id: "25_cars", title: "Growing Collection", description: "Collect 25 cars", category: .collection, coinReward: 100, requirement: 25, iconName: "car.circle.fill"),
            Achievement(id: "50_cars", title: "Serious Collector", description: "Collect 50 cars", category: .collection, coinReward: 200, requirement: 50, iconName: "car.ferry"),
            Achievement(id: "75_cars", title: "Car Connoisseur", description: "Collect 75 cars", category: .collection, coinReward: 300, requirement: 75, iconName: "car.top.radiowaves.front"),
            Achievement(id: "100_cars", title: "Century Club", description: "Collect 100 cars", category: .collection, coinReward: 500, requirement: 100, iconName: "100.circle.fill"),
            Achievement(id: "150_cars", title: "Master Collector", description: "Collect 150 cars", category: .collection, coinReward: 750, requirement: 150, iconName: "star.fill"),
            Achievement(id: "200_cars", title: "Legend", description: "Collect 200 cars", category: .collection, coinReward: 1000, requirement: 200, iconName: "crown.fill"),
            Achievement(id: "300_cars", title: "Ultimate Collection", description: "Collect 300 cars", category: .collection, coinReward: 2000, requirement: 300, iconName: "diamond.fill"),
            Achievement(id: "favorite_5", title: "Favorites", description: "Mark 5 cars as favorites", category: .collection, coinReward: 30, requirement: 5, iconName: "star.circle.fill"),
            Achievement(id: "favorite_25", title: "Beloved Collection", description: "Mark 25 cars as favorites", category: .collection, coinReward: 150, requirement: 25, iconName: "sparkles"),
            Achievement(id: "notes_10", title: "Storyteller", description: "Add notes to 10 cars", category: .collection, coinReward: 40, requirement: 10, iconName: "note.text"),
            Achievement(id: "notes_50", title: "Detailed Archivist", description: "Add notes to 50 cars", category: .collection, coinReward: 200, requirement: 50, iconName: "book.fill"),
            Achievement(id: "daily_scan_3", title: "Three Day Streak", description: "Scan cars for 3 days in a row", category: .dedication, coinReward: 50, requirement: 3, iconName: "flame.fill"),
            Achievement(id: "daily_scan_7", title: "Week Warrior", description: "Scan cars for 7 days in a row", category: .dedication, coinReward: 100, requirement: 7, iconName: "calendar.badge.clock"),
            Achievement(id: "daily_scan_30", title: "Monthly Dedication", description: "Scan cars for 30 days in a row", category: .dedication, coinReward: 500, requirement: 30, iconName: "medal.fill"),
            Achievement(id: "one_day_5", title: "Productive Day", description: "Scan 5 cars in one day", category: .dedication, coinReward: 40, requirement: 5, iconName: "sunrise.fill"),
            Achievement(id: "one_day_10", title: "Car Spotting Spree", description: "Scan 10 cars in one day", category: .dedication, coinReward: 100, requirement: 10, iconName: "sun.max.fill"),
            Achievement(id: "one_day_25", title: "Super Spotter", description: "Scan 25 cars in one day", category: .dedication, coinReward: 300, requirement: 25, iconName: "sparkles.square.filled.on.square"),
            
            // RARITY ACHIEVEMENTS (30)
            Achievement(id: "common_10", title: "Common Grounds", description: "Collect 10 Common cars", category: .rarity, coinReward: 20, requirement: 10, iconName: "circle.fill"),
            Achievement(id: "common_50", title: "Everyday Enthusiast", description: "Collect 50 Common cars", category: .rarity, coinReward: 100, requirement: 50, iconName: "circle.grid.3x3.fill"),
            Achievement(id: "uncommon_5", title: "Rising Interest", description: "Collect 5 Uncommon cars", category: .rarity, coinReward: 30, requirement: 5, iconName: "circle.hexagongrid.fill"),
            Achievement(id: "uncommon_25", title: "Premium Seeker", description: "Collect 25 Uncommon cars", category: .rarity, coinReward: 150, requirement: 25, iconName: "hexagon.fill"),
            Achievement(id: "rare_3", title: "Rare Find", description: "Collect 3 Rare cars", category: .rarity, coinReward: 50, requirement: 3, iconName: "diamond"),
            Achievement(id: "rare_10", title: "Luxury Lover", description: "Collect 10 Rare cars", category: .rarity, coinReward: 200, requirement: 10, iconName: "gem.fill"),
            Achievement(id: "rare_25", title: "High Performance", description: "Collect 25 Rare cars", category: .rarity, coinReward: 500, requirement: 25, iconName: "bolt.fill"),
            Achievement(id: "exotic_1", title: "First Exotic", description: "Collect your first Exotic car", category: .rarity, coinReward: 100, requirement: 1, iconName: "star.circle.fill"),
            Achievement(id: "exotic_5", title: "Supercar Collector", description: "Collect 5 Exotic cars", category: .rarity, coinReward: 300, requirement: 5, iconName: "flame.circle.fill"),
            Achievement(id: "exotic_15", title: "Elite Fleet", description: "Collect 15 Exotic cars", category: .rarity, coinReward: 750, requirement: 15, iconName: "sparkle"),
            Achievement(id: "legendary_1", title: "Legendary Moment", description: "Collect your first Legendary car", category: .rarity, coinReward: 200, requirement: 1, iconName: "trophy.fill"),
            Achievement(id: "legendary_3", title: "Hypercar Hunter", description: "Collect 3 Legendary cars", category: .rarity, coinReward: 500, requirement: 3, iconName: "crown"),
            Achievement(id: "legendary_10", title: "Ultimate Collection", description: "Collect 10 Legendary cars", category: .rarity, coinReward: 1500, requirement: 10, iconName: "shield.fill"),
            Achievement(id: "all_rarities", title: "Rainbow Collection", description: "Own at least one of each rarity", category: .rarity, coinReward: 250, requirement: 5, iconName: "paintpalette.fill"),
            Achievement(id: "balanced_10", title: "Balanced Collector", description: "Have 10+ cars in each rarity", category: .rarity, coinReward: 500, requirement: 10, iconName: "equal.circle.fill"),
            Achievement(id: "rare_only_10", title: "Only the Best", description: "Collect 10 cars of Rare or higher", category: .rarity, coinReward: 300, requirement: 10, iconName: "rosette"),
            Achievement(id: "exotic_streak_3", title: "Exotic Streak", description: "Find 3 Exotic+ cars in a row", category: .rarity, coinReward: 400, requirement: 3, iconName: "arrow.up.circle.fill"),
            Achievement(id: "legendary_week", title: "Golden Week", description: "Find a Legendary car 7 days in a row", category: .rarity, coinReward: 1000, requirement: 7, iconName: "calendar.badge.plus"),
            Achievement(id: "mixed_day", title: "Variety Spotter", description: "Find all 5 rarities in one day", category: .rarity, coinReward: 350, requirement: 5, iconName: "checkerboard.shield"),
            Achievement(id: "upgrade_collection", title: "Upgrading", description: "Replace 10 Common cars with Rare+", category: .rarity, coinReward: 200, requirement: 10, iconName: "arrow.up.square.fill"),
            Achievement(id: "rarity_master", title: "Rarity Master", description: "Collect 25+ of each rarity type", category: .rarity, coinReward: 1000, requirement: 25, iconName: "star.square.fill"),
            Achievement(id: "exotic_dominance", title: "Exotic Dominance", description: "Have 50% of collection be Exotic+", category: .rarity, coinReward: 800, requirement: 50, iconName: "percent"),
            Achievement(id: "common_purge", title: "Quality Over Quantity", description: "Have under 10% Common cars in 100+ collection", category: .rarity, coinReward: 400, requirement: 10, iconName: "trash.circle"),
            Achievement(id: "legendary_focus", title: "Legendary Focus", description: "Collect 5 Legendary before 50 total cars", category: .rarity, coinReward: 600, requirement: 5, iconName: "target"),
            Achievement(id: "rarity_pyramid", title: "Perfect Pyramid", description: "Have each rarity tier decrease by 50%", category: .rarity, coinReward: 500, requirement: 1, iconName: "pyramid.fill"),
            Achievement(id: "exotic_collector", title: "Exotic Only Club", description: "Own 50 Exotic+ cars", category: .rarity, coinReward: 1200, requirement: 50, iconName: "automobile.fill"),
            Achievement(id: "legendary_hunter", title: "Legendary Hunter", description: "Own 20 Legendary cars", category: .rarity, coinReward: 2000, requirement: 20, iconName: "flag.checkered.2.crossed"),
            Achievement(id: "diverse_rare", title: "Diverse Excellence", description: "Own 100 cars of Rare+ quality", category: .rarity, coinReward: 1500, requirement: 100, iconName: "square.3.layers.3d"),
            Achievement(id: "no_common", title: "Elite Only", description: "Have 0 Common cars in 200+ collection", category: .rarity, coinReward: 1000, requirement: 200, iconName: "xmark.circle"),
            Achievement(id: "full_legendary", title: "Hall of Legends", description: "Own 50 Legendary cars", category: .rarity, coinReward: 5000, requirement: 50, iconName: "building.columns.fill"),
            
            // POINTS ACHIEVEMENTS (20)
            Achievement(id: "100_points", title: "Century", description: "Earn 100 points", category: .points, coinReward: 20, requirement: 100, iconName: "100.square"),
            Achievement(id: "500_points", title: "Point Collector", description: "Earn 500 points", category: .points, coinReward: 50, requirement: 500, iconName: "star.leadinghalf.filled"),
            Achievement(id: "1000_points", title: "Thousand Club", description: "Earn 1,000 points", category: .points, coinReward: 100, requirement: 1000, iconName: "1000.circle.fill"),
            Achievement(id: "2500_points", title: "Point Master", description: "Earn 2,500 points", category: .points, coinReward: 200, requirement: 2500, iconName: "chart.line.uptrend.xyaxis"),
            Achievement(id: "5000_points", title: "Five Thousand", description: "Earn 5,000 points", category: .points, coinReward: 400, requirement: 5000, iconName: "5000.circle"),
            Achievement(id: "10000_points", title: "Ten Thousand", description: "Earn 10,000 points", category: .points, coinReward: 750, requirement: 10000, iconName: "mountain.2.fill"),
            Achievement(id: "25000_points", title: "Point Tycoon", description: "Earn 25,000 points", category: .points, coinReward: 1500, requirement: 25000, iconName: "diamond.inset.filled"),
            Achievement(id: "50000_points", title: "Fifty Thousand", description: "Earn 50,000 points", category: .points, coinReward: 2500, requirement: 50000, iconName: "trophy.circle.fill"),
            Achievement(id: "100000_points", title: "Six Figures", description: "Earn 100,000 points", category: .points, coinReward: 5000, requirement: 100000, iconName: "shippingbox.fill"),
            Achievement(id: "250000_points", title: "Quarter Million", description: "Earn 250,000 points", category: .points, coinReward: 10000, requirement: 250000, iconName: "banknote.fill"),
            Achievement(id: "500_one_day", title: "Daily Excellence", description: "Earn 500 points in one day", category: .points, coinReward: 150, requirement: 500, iconName: "calendar.day.timeline.left"),
            Achievement(id: "1000_one_day", title: "Thousand Day", description: "Earn 1,000 points in one day", category: .points, coinReward: 400, requirement: 1000, iconName: "calendar.badge.exclamationmark"),
            Achievement(id: "avg_50", title: "Quality Collector", description: "Average 50+ points per car", category: .points, coinReward: 300, requirement: 50, iconName: "chart.bar.fill"),
            Achievement(id: "avg_100", title: "Elite Standards", description: "Average 100+ points per car", category: .points, coinReward: 600, requirement: 100, iconName: "chart.bar.xaxis"),
            Achievement(id: "single_200", title: "Big Score", description: "Find a single car worth 200+ points", category: .points, coinReward: 250, requirement: 200, iconName: "bolt.circle.fill"),
            Achievement(id: "week_1000", title: "Productive Week", description: "Earn 1,000 points in a week", category: .points, coinReward: 300, requirement: 1000, iconName: "calendar.circle.fill"),
            Achievement(id: "month_5000", title: "Monthly Milestone", description: "Earn 5,000 points in a month", category: .points, coinReward: 800, requirement: 5000, iconName: "calendar.badge.checkmark"),
            Achievement(id: "consistent_100", title: "Consistency", description: "Earn 100+ points 10 days in a row", category: .points, coinReward: 500, requirement: 10, iconName: "arrow.clockwise.circle.fill"),
            Achievement(id: "point_multiplier", title: "Multiplier", description: "Earn 10x your level in points in one day", category: .points, coinReward: 400, requirement: 10, iconName: "multiply.circle.fill"),
            Achievement(id: "efficiency", title: "Efficient Collector", description: "Reach 10,000 points with under 100 cars", category: .points, coinReward: 700, requirement: 10000, iconName: "gauge.high"),
            
            // LEVEL ACHIEVEMENTS (15)
            Achievement(id: "level_5", title: "Level 5", description: "Reach Level 5", category: .level, coinReward: 25, requirement: 5, iconName: "5.square.fill"),
            Achievement(id: "level_10", title: "Level 10", description: "Reach Level 10", category: .level, coinReward: 50, requirement: 10, iconName: "10.square.fill"),
            Achievement(id: "level_25", title: "Level 25", description: "Reach Level 25", category: .level, coinReward: 150, requirement: 25, iconName: "25.square.fill"),
            Achievement(id: "level_50", title: "Halfway", description: "Reach Level 50", category: .level, coinReward: 500, requirement: 50, iconName: "50.square.fill"),
            Achievement(id: "level_75", title: "Level 75", description: "Reach Level 75", category: .level, coinReward: 1000, requirement: 75, iconName: "75.square.fill"),
            Achievement(id: "level_100", title: "Maximum Level", description: "Reach Level 100", category: .level, coinReward: 5000, requirement: 100, iconName: "100.circle.fill"),
            Achievement(id: "fast_level_10", title: "Speed Leveler", description: "Reach Level 10 in 7 days", category: .level, coinReward: 200, requirement: 10, iconName: "hare.fill"),
            Achievement(id: "fast_level_25", title: "Rapid Rise", description: "Reach Level 25 in 30 days", category: .level, coinReward: 500, requirement: 25, iconName: "tornado"),
            Achievement(id: "level_up_5", title: "Growth Spurt", description: "Level up 5 times in one day", category: .level, coinReward: 300, requirement: 5, iconName: "arrow.up.forward.circle.fill"),
            Achievement(id: "steady_pace", title: "Steady Progress", description: "Level up every day for a week", category: .level, coinReward: 400, requirement: 7, iconName: "figure.walk"),
            Achievement(id: "double_digits", title: "Double Digits", description: "Reach any level ending in 00", category: .level, coinReward: 250, requirement: 10, iconName: "00.circle.fill"),
            Achievement(id: "halfway_month", title: "Quick Climber", description: "Reach Level 50 in 60 days", category: .level, coinReward: 800, requirement: 50, iconName: "mountain.2.circle.fill"),
            Achievement(id: "level_grind", title: "Dedicated Grinder", description: "Stay at max level for 30 days", category: .level, coinReward: 1000, requirement: 30, iconName: "figure.strengthtraining.traditional"),
            Achievement(id: "never_stop", title: "Never Stop Growing", description: "Maintain 90+ level for 90 days", category: .level, coinReward: 1500, requirement: 90, iconName: "infinity.circle.fill"),
            Achievement(id: "perfect_pace", title: "Perfect Pace", description: "Level up exactly once per day for 30 days", category: .level, coinReward: 1200, requirement: 30, iconName: "metronome.fill"),
            
            // SPECIFIC CAR ACHIEVEMENTS (15)
            Achievement(id: "german_5", title: "German Engineering", description: "Collect 5 German cars (BMW, Mercedes, Audi, Porsche)", category: .specific, coinReward: 75, requirement: 5, iconName: "flag.fill"),
            Achievement(id: "japanese_10", title: "JDM Lover", description: "Collect 10 Japanese cars (Toyota, Honda, Nissan, Mazda)", category: .specific, coinReward: 100, requirement: 10, iconName: "japan.flag"),
            Achievement(id: "american_muscle", title: "American Muscle", description: "Collect 5 American muscle cars (Mustang, Camaro, Challenger)", category: .specific, coinReward: 100, requirement: 5, iconName: "flag.checkered"),
            Achievement(id: "italian_exotic", title: "Italian Style", description: "Collect 3 Italian exotics (Ferrari, Lamborghini, Maserati)", category: .specific, coinReward: 200, requirement: 3, iconName: "laurel.leading"),
            Achievement(id: "british_luxury", title: "British Luxury", description: "Collect 3 British luxury cars (Rolls-Royce, Bentley, Aston Martin)", category: .specific, coinReward: 200, requirement: 3, iconName: "crown.fill"),
            Achievement(id: "electric_5", title: "Future Forward", description: "Collect 5 electric vehicles", category: .specific, coinReward: 80, requirement: 5, iconName: "bolt.car.fill"),
            Achievement(id: "classic_3", title: "Classic Collector", description: "Collect 3 classic cars (20+ years old)", category: .specific, coinReward: 150, requirement: 3, iconName: "clock.arrow.circlepath"),
            Achievement(id: "suv_10", title: "SUV Enthusiast", description: "Collect 10 SUVs", category: .specific, coinReward: 70, requirement: 10, iconName: "suv.side.fill"),
            Achievement(id: "sports_15", title: "Sports Car Fan", description: "Collect 15 sports cars", category: .specific, coinReward: 120, requirement: 15, iconName: "sportscourt.fill"),
            Achievement(id: "luxury_sedan", title: "Executive Choice", description: "Collect 10 luxury sedans", category: .specific, coinReward: 100, requirement: 10, iconName: "car.rear.fill"),
            Achievement(id: "supercar_5", title: "Supercar Collection", description: "Collect 5 supercars (Ferrari, McLaren, Lamborghini)", category: .specific, coinReward: 300, requirement: 5, iconName: "flame.fill"),
            Achievement(id: "hypercar_3", title: "Hypercar Elite", description: "Collect 3 hypercars (Bugatti, Koenigsegg, Pagani)", category: .specific, coinReward: 500, requirement: 3, iconName: "wind"),
            Achievement(id: "convertible_5", title: "Top Down", description: "Collect 5 convertibles", category: .specific, coinReward: 60, requirement: 5, iconName: "sun.horizon.fill"),
            Achievement(id: "truck_10", title: "Truck Collector", description: "Collect 10 pickup trucks", category: .specific, coinReward: 75, requirement: 10, iconName: "truck.box.fill"),
            Achievement(id: "one_brand_25", title: "Brand Loyalty", description: "Collect 25 cars from one manufacturer", category: .specific, coinReward: 250, requirement: 25, iconName: "building.2.fill"),
        ]
    }
    
    // MARK: - Check Achievements
    func checkAchievements(cars: [Car], level: Int, totalPoints: Int) {
        var newlyUnlocked: [Achievement] = []
        
        for index in achievements.indices {
            var achievement = achievements[index]
            
            if achievement.isUnlocked { continue }
            
            var shouldUnlock = false
            
            switch achievement.id {
            // Collection achievements
            case "first_car": shouldUnlock = cars.count >= 1
            case "5_cars": shouldUnlock = cars.count >= 5
            case "10_cars": shouldUnlock = cars.count >= 10
            case "25_cars": shouldUnlock = cars.count >= 25
            case "50_cars": shouldUnlock = cars.count >= 50
            case "75_cars": shouldUnlock = cars.count >= 75
            case "100_cars": shouldUnlock = cars.count >= 100
            case "150_cars": shouldUnlock = cars.count >= 150
            case "200_cars": shouldUnlock = cars.count >= 200
            case "300_cars": shouldUnlock = cars.count >= 300
                
            // Favorite achievements
            case "favorite_5": shouldUnlock = cars.filter({ $0.isFavorite == true }).count >= 5
            case "favorite_25": shouldUnlock = cars.filter({ $0.isFavorite == true }).count >= 25
                
            // Notes achievements
            case "notes_10": shouldUnlock = cars.filter({ ($0.notes ?? "").count > 0 }).count >= 10
            case "notes_50": shouldUnlock = cars.filter({ ($0.notes ?? "").count > 0 }).count >= 50
                
            // Rarity achievements
            case "common_10": shouldUnlock = cars.filter({ $0.carCategory == .common }).count >= 10
            case "common_50": shouldUnlock = cars.filter({ $0.carCategory == .common }).count >= 50
            case "uncommon_5": shouldUnlock = cars.filter({ $0.carCategory == .uncommon }).count >= 5
            case "uncommon_25": shouldUnlock = cars.filter({ $0.carCategory == .uncommon }).count >= 25
            case "rare_3": shouldUnlock = cars.filter({ $0.carCategory == .rare }).count >= 3
            case "rare_10": shouldUnlock = cars.filter({ $0.carCategory == .rare }).count >= 10
            case "rare_25": shouldUnlock = cars.filter({ $0.carCategory == .rare }).count >= 25
            case "exotic_1": shouldUnlock = cars.filter({ $0.carCategory == .exotic }).count >= 1
            case "exotic_5": shouldUnlock = cars.filter({ $0.carCategory == .exotic }).count >= 5
            case "exotic_15": shouldUnlock = cars.filter({ $0.carCategory == .exotic }).count >= 15
            case "legendary_1": shouldUnlock = cars.filter({ $0.carCategory == .legendary }).count >= 1
            case "legendary_3": shouldUnlock = cars.filter({ $0.carCategory == .legendary }).count >= 3
            case "legendary_10": shouldUnlock = cars.filter({ $0.carCategory == .legendary }).count >= 10
            case "all_rarities":
                let hasCommon = cars.contains { $0.carCategory == .common }
                let hasUncommon = cars.contains { $0.carCategory == .uncommon }
                let hasRare = cars.contains { $0.carCategory == .rare }
                let hasExotic = cars.contains { $0.carCategory == .exotic }
                let hasLegendary = cars.contains { $0.carCategory == .legendary }
                shouldUnlock = hasCommon && hasUncommon && hasRare && hasExotic && hasLegendary
                
            // Points achievements
            case "100_points": shouldUnlock = totalPoints >= 100
            case "500_points": shouldUnlock = totalPoints >= 500
            case "1000_points": shouldUnlock = totalPoints >= 1000
            case "2500_points": shouldUnlock = totalPoints >= 2500
            case "5000_points": shouldUnlock = totalPoints >= 5000
            case "10000_points": shouldUnlock = totalPoints >= 10000
            case "25000_points": shouldUnlock = totalPoints >= 25000
            case "50000_points": shouldUnlock = totalPoints >= 50000
            case "100000_points": shouldUnlock = totalPoints >= 100000
            case "250000_points": shouldUnlock = totalPoints >= 250000
                
            // Level achievements
            case "level_5": shouldUnlock = level >= 5
            case "level_10": shouldUnlock = level >= 10
            case "level_25": shouldUnlock = level >= 25
            case "level_50": shouldUnlock = level >= 50
            case "level_75": shouldUnlock = level >= 75
            case "level_100": shouldUnlock = level >= 100
                
            default: break
            }
            
            if shouldUnlock {
                achievement.isUnlocked = true
                achievement.unlockedDate = Date()
                achievements[index] = achievement
                newlyUnlocked.append(achievement)
                totalCoins += achievement.coinReward
                unlockedAchievements.append(achievement.id)
            }
        }
        
        if !newlyUnlocked.isEmpty {
            hasNewAchievements = true
            saveUserProgress()
        }
    }
    
    // MARK: - Persistence
    func saveUserProgress() {
        UserDefaults.standard.set(unlockedAchievements, forKey: "unlockedAchievements")
        UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
    }
    
    func loadUserProgress() {
        unlockedAchievements = UserDefaults.standard.stringArray(forKey: "unlockedAchievements") ?? []
        totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        
        // Update achievements with unlocked status
        for index in achievements.indices {
            if unlockedAchievements.contains(achievements[index].id) {
                achievements[index].isUnlocked = true
            }
        }
    }
}
