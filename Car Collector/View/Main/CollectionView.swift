//
//  CollectionView.swift
//  Car Collector
//  Updated with swipe-to-delete and detail view navigation
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct CollectionView: View {
    @State private var cars: [Car] = []
    @State private var isLoading = true
    @State private var selectedCar: Car?
    @State private var showCarDetail = false
    @State private var carToDelete: Car?
    @State private var showDeleteConfirmation = false
    @State private var searchText: String = ""
    @State private var selectedCategory: CarCategory?
    @State private var showFavoritesOnly: Bool = false
    @FocusState private var isSearchFieldFocused: Bool
    
    // Filtered cars based on search and filters
    var filteredCars: [Car] {
        var result = cars
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { car in
                car.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Apply category filter
        if let category = selectedCategory {
            result = result.filter { car in
                car.carCategory == category
            }
        }
        
        // Apply favorites filter
        if showFavoritesOnly {
            result = result.filter { car in
                car.isFavorite == true
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with title and count
            HStack {
                Text("My Collection")
                    .font(.system(size: 34, weight: .bold))
                
                Spacer()
                
                Text("\(filteredCars.count)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
            }
            .padding()
            .background(Color.white)
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search cars...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isSearchFieldFocused)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Filter Buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // Favorites Filter
                    Button(action: {
                        showFavoritesOnly.toggle()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                            Text("Favorites")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(showFavoritesOnly ? .white : .primary)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(showFavoritesOnly ? Color.yellow : Color.gray.opacity(0.15))
                        .cornerRadius(20)
                    }
                    
                    // Category Filters
                    ForEach(CarCategory.allCases, id: \.self) { category in
                        Button(action: {
                            if selectedCategory == category {
                                selectedCategory = nil
                            } else {
                                selectedCategory = category
                            }
                        }) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(categoryColor(for: category))
                                    .frame(width: 8, height: 8)
                                
                                Text(category.rawValue)
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? categoryColor(for: category) : Color.gray.opacity(0.15))
                            .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .background(Color.white)
            
            if isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            } else if cars.isEmpty {
                Spacer()
                VStack(spacing: 20) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No cars collected yet")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text("Start scanning cars to build your collection!")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                Spacer()
            } else if filteredCars.isEmpty {
                Spacer()
                VStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 80))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No cars found")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text("Try adjusting your search or filters")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                Spacer()
            } else {
                List {
                    ForEach(filteredCars) { car in
                        Button(action: {
                            openCarDetail(car)
                        }) {
                            CarCardView(car: car)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowInsets(EdgeInsets(top: 7.5, leading: 16, bottom: 7.5, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.gray.opacity(0.05))
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                confirmDelete(car)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color.gray.opacity(0.05))
            }
        }
        .background(Color.gray.opacity(0.05))
        .onAppear {
            loadCars()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToCollectionTab"))) { _ in
            print("🔵 CollectionView received tab switch notification, reloading cars...")
            loadCars()
        }
        .sheet(isPresented: $showCarDetail) {
            if let car = selectedCar {
                CarDetailPageView(car: car)
            }
        }
        .alert("Delete Car", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                carToDelete = nil
            }
            Button("Confirm", role: .destructive) {
                if let car = carToDelete {
                    deleteCar(car)
                }
                carToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this car?")
        }
    }
    
    func confirmDelete(_ car: Car) {
        carToDelete = car
        showDeleteConfirmation = true
    }
    
    func openCarDetail(_ car: Car) {
        selectedCar = car
        showCarDetail = true
    }
    
    func loadCars() {
        print("📱 CollectionView: Loading cars from Firestore...")
        let db = Firestore.firestore()
        
        db.collection("cars")
            .order(by: "dateCaptured", descending: true)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    isLoading = false
                    
                    if let error = error {
                        print("❌ Error loading cars: \(error.localizedDescription)")
                        print("❌ Error code: \((error as NSError).code)")
                        print("❌ Error domain: \((error as NSError).domain)")
                        cars = []
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("⚠️ No documents found (snapshot.documents is nil)")
                        cars = []
                        return
                    }
                    
                    print("✅ Found \(documents.count) documents in Firestore")
                    
                    if documents.isEmpty {
                        print("⚠️ Collection exists but is empty - no cars saved yet")
                        cars = []
                        return
                    }
                    
                    // Log the first document to see its structure
                    if let firstDoc = documents.first {
                        print("📄 Sample document data: \(firstDoc.data())")
                    }
                    
                    cars = documents.compactMap { document in
                        do {
                            let car = try document.data(as: Car.self)
                            print("✅ Successfully parsed car: \(car.name)")
                            return car
                        } catch {
                            print("❌ Failed to parse document \(document.documentID): \(error.localizedDescription)")
                            print("❌ Document data: \(document.data())")
                            return nil
                        }
                    }
                    
                    print("✅ Successfully parsed \(cars.count) cars out of \(documents.count) documents")
                }
            }
    }
    
    func deleteCar(_ car: Car) {
        guard let carId = car.id else {
            print("❌ Cannot delete car: no ID")
            return
        }
        
        print("🗑️ Deleting car: \(car.name) (ID: \(carId))")
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        // Delete image from storage if it exists
        if let imageURL = car.imageURL, let url = URL(string: imageURL) {
            let imageRef = storage.reference(forURL: url.absoluteString)
            imageRef.delete { error in
                if let error = error {
                    print("⚠️ Failed to delete image: \(error.localizedDescription)")
                } else {
                    print("✅ Image deleted from storage")
                }
            }
        }
        
        // Delete document from Firestore
        db.collection("cars").document(carId).delete { error in
            if let error = error {
                print("❌ Error deleting car from Firestore: \(error.localizedDescription)")
            } else {
                print("✅ Car deleted successfully from Firestore")
            }
        }
    }
    
    func categoryColor(for category: CarCategory) -> Color {
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
}

struct CarCardView: View {
    let car: Car
    @State private var carImage: UIImage?
    @State private var isLoadingImage = true
    
    // Helper to get category badge color (solid)
    var categoryBadgeColor: Color {
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
    
    // Remove year range from car name
    var displayName: String {
        let name = car.name
        // Remove patterns like "2020-2023 " or "2020 " from the beginning
        let pattern = "^\\d{4}(-\\d{4})?\\s+"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(name.startIndex..., in: name)
            let cleanedName = regex.stringByReplacingMatches(in: name, options: [], range: range, withTemplate: "")
            return cleanedName
        }
        return name
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Car Image
            Group {
                if isLoadingImage {
                    ProgressView()
                        .frame(width: 60, height: 60)
                } else {
                    if let carImage = carImage {
                        Image(uiImage: carImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipped()
                            .cornerRadius(10)
                            .rotationEffect(.degrees(270))
                    } else {
                        Image(systemName: "car.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipped()
                            .cornerRadius(10)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
            }
            .frame(width: 60, height: 60)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Car Details
            VStack(alignment: .leading, spacing: 6) {
                Text(displayName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                // Category badge instead of points
                HStack(spacing: 6) {
                    Circle()
                        .fill(categoryBadgeColor)
                        .frame(width: 8, height: 8)
                    
                    Text(car.carCategory.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(categoryBadgeColor)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        .onAppear {
            loadCarImage()
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
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    CollectionView()
}
