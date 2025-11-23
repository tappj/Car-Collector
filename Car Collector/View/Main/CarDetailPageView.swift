//
//  CarDetailPageView.swift
//  Car Collector
//

import SwiftUI
import FirebaseFirestore

struct CarDetailPageView: View {
    let car: Car
    @Environment(\.dismiss) var dismiss
    @State private var carImage: UIImage?
    @State private var isLoadingImage = true
    @State private var isFavorite: Bool = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var notes: String = ""
    @FocusState private var isNotesFieldFocused: Bool
    
    // Computed properties for rarity display
    var categoryColor: Color {
        let category = car.carCategory
        switch category {
        case .common:
            return Color.gray
        case .uncommon:
            return Color.blue
        case .rare:
            return Color.purple
        case .exotic:
            return Color.orange
        case .legendary:
            return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold
        }
    }
    
    var rarityProgress: CGFloat {
        let category = car.carCategory
        switch category {
        case .common: return 0.2
        case .uncommon: return 0.4
        case .rare: return 0.6
        case .exotic: return 0.8
        case .legendary: return 1.0
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Car Image
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.blue.opacity(0.1))
                            .frame(height: 300)
                        
                        if isLoadingImage {
                            ProgressView()
                                .scaleEffect(1.5)
                        } else if let image = carImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .rotationEffect(.degrees(270))
                                .frame(height: 300)
                                .clipped()
                        } else {
                            Image(systemName: "car.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.blue.opacity(0.3))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    
                    // Car Information
                    VStack(alignment: .leading, spacing: 15) {
                        // Name with Favorite Button
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Car Name")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                                Text(car.name)
                                    .font(.system(size: 22, weight: .bold))
                            }
                            
                            Spacer()
                            
                            // Favorite Star Button
                            Button(action: {
                                toggleFavorite()
                            }) {
                                Image(systemName: isFavorite ? "star.fill" : "star")
                                    .font(.system(size: 28))
                                    .foregroundColor(isFavorite ? .yellow : .gray)
                            }
                            .padding(.top, 20)
                        }
                        
                        // Rarity Bar
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(car.carCategory.rawValue)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(categoryColor)
                                
                                Spacer()
                                
                                Text("+\(car.points) points")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(categoryColor)
                            }
                            
                            // Rarity Progress Bar
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    // Background
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(categoryColor.opacity(0.2))
                                        .frame(height: 12)
                                    
                                    // Filled portion based on rarity
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(categoryColor)
                                        .frame(width: geometry.size.width * rarityProgress, height: 12)
                                }
                            }
                            .frame(height: 12)
                        }
                        .padding(.top, 5)
                        
                        Divider()
                        
                        // Notes Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Personal Notes")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $notes)
                                .frame(minHeight: 100, maxHeight: 120)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .focused($isNotesFieldFocused)
                                .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            Button("Done") {
                                                isNotesFieldFocused = false
                                            }
                                        }
                                    }
                                .onChange(of: notes) { newValue in
                                    // Limit to 250 characters
                                    if newValue.count > 250 {
                                        notes = String(newValue.prefix(250))
                                    }
                                }
                                .overlay(
                                    VStack {
                                        if notes.isEmpty && !isNotesFieldFocused {
                                            HStack {
                                                Text("Add notes about this car (mods, location, personal details, etc.)")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray.opacity(0.6))
                                                    .padding(.leading, 12)
                                                    .padding(.top, 16)
                                                Spacer()
                                            }
                                        }
                                        Spacer()
                                    }
                                    .allowsHitTesting(false)
                                )
                            
                            HStack {
                                Spacer()
                                Text("\(notes.count)/250")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
                        // Date Captured
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Date Captured")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                                Text(formatDate(car.dateCaptured))
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .font(.system(size: 24))
                                .foregroundColor(.blue.opacity(0.5))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    Spacer()
                }
            }
            .navigationTitle("Car Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                }
            }
            .overlay(
                // Toast Message
                VStack {
                    Spacer()
                    if showToast {
                        Text(toastMessage)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(25)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showToast)
            )
        }
        .onAppear {
            loadCarImage()
            isFavorite = car.isFavorite ?? false
            notes = car.notes ?? ""
        }
        .onDisappear {
            saveNotes()
        }
    }
    
    func loadCarImage() {
        guard let imageURLString = car.imageURL,
              let url = URL(string: imageURLString) else {
            isLoadingImage = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoadingImage = false
                
                if let data = data, let image = UIImage(data: data) {
                    carImage = image
                }
            }
        }.resume()
    }
    
    func toggleFavorite() {
        guard let carId = car.id else {
            print("❌ Cannot toggle favorite: no car ID")
            return
        }
        
        // Toggle the local state
        isFavorite.toggle()
        
        // Update Firestore
        let db = Firestore.firestore()
        db.collection("cars").document(carId).updateData([
            "isFavorite": isFavorite
        ]) { error in
            if let error = error {
                print("❌ Error updating favorite status: \(error.localizedDescription)")
                // Revert the change if update failed
                DispatchQueue.main.async {
                    isFavorite.toggle()
                }
            } else {
                print("✅ Favorite status updated successfully")
                // Show toast message
                DispatchQueue.main.async {
                    toastMessage = isFavorite ? "Car favorited" : "Car unfavorited"
                    withAnimation {
                        showToast = true
                    }
                    
                    // Hide toast after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                }
            }
        }
    }
    
    func saveNotes() {
        guard let carId = car.id else {
            print("❌ Cannot save notes: no car ID")
            return
        }
        
        // Only save if notes have changed
        if notes != (car.notes ?? "") {
            let db = Firestore.firestore()
            db.collection("cars").document(carId).updateData([
                "notes": notes
            ]) { error in
                if let error = error {
                    print("❌ Error saving notes: \(error.localizedDescription)")
                } else {
                    print("✅ Notes saved successfully")
                }
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
