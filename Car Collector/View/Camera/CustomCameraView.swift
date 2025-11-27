//
//  CustomCameraView.swift
//  Car Collector
//

import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import AVFoundation
import Combine

struct CustomCameraView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var camera = CameraModel()
    @State private var capturedImage: UIImage?
    @State private var isIdentifying = false
    @State private var identifiedCar = ""
    @State private var showFlash = false
    @State private var cameraReady = false
    @State private var showCaptureFrame = true
    @State private var isReviewingPhoto = false
    @State private var showNotCarAlert = false
    @State private var carCategory: CarCategory = .common
    @State private var earnedPoints: Int = 10
    
    var body: some View {
        ZStack {
            if cameraReady {
                cameraView
            } else {
                loadingSplash
            }
        }
        .onAppear {
            camera.checkPermissions {
                withAnimation(.easeIn(duration: 0.3)) {
                    cameraReady = true
                }
            }
        }
    }
    
    var loadingSplash: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("Loading Camera...")
                    .font(.title2)
                    .foregroundColor(.white)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
    
    struct ScanningOverlay: View {
        @State private var rotation: Double = 0
        @State private var dotCount: Int = 0
        
        let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
        
        var body: some View {
            ZStack {
                // Modern minimal loading spinner
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotation))
                
                VStack {
                    Spacer()
                    
                    Text("Analyzing" + String(repeating: ".", count: dotCount))
                        .font(.system(size: 20, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.bottom, 100)
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
            .onReceive(timer) { _ in
                dotCount = (dotCount + 1) % 4
            }
        }
    }
    
    struct CelebrationView: View {
        let carName: String
        let category: CarCategory
        let points: Int
        let onScanAnother: () -> Void
        let onViewCollection: () -> Void
        
        @State private var scale: CGFloat = 0.5
        @State private var opacity: Double = 0
        
        var categoryColor: Color {
            switch category {
            case .common: return .gray
            case .uncommon: return .blue
            case .rare: return .purple
            case .exotic: return .orange
            case .legendary: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold
            }
        }
        
        var body: some View {
            ZStack {
                Color.black.opacity(0.85)
                    .edgesIgnoringSafeArea(.all)
                
                ConfettiView()
                
                VStack(spacing: 25) {
                    ZStack {
                        Circle()
                            .fill(categoryColor)
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "car.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 10) {
                        Text("Car Found!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        // Category badge
                        HStack(spacing: 6) {
                            Circle()
                                .fill(categoryColor)
                                .frame(width: 12, height: 12)
                            
                            Text(category.rawValue)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(categoryColor)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(categoryColor.opacity(0.2))
                        .cornerRadius(20)
                    }
                    
                    Text(carName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("+\(points) Points")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    .padding(.top, 10)
                    
                    VStack(spacing: 15) {
                        Button(action: onViewCollection) {
                            HStack {
                                Image(systemName: "rectangle.stack.fill")
                                    .font(.title3)
                                Text("View Collection")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                        }
                        
                        Button(action: onScanAnother) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.title3)
                                Text("Scan Another")
                                    .font(.headline)
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                }
                .padding(30)
                .background(Color.black.opacity(0.9))
                .cornerRadius(25)
                .padding(40)
                .scaleEffect(scale)
                .opacity(opacity)
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
    
    struct ConfettiView: View {
        @State private var animate = false
        
        var body: some View {
            ZStack {
                ForEach(0..<30) { index in
                    ConfettiPiece(index: index)
                        .offset(y: animate ? 800 : -100)
                        .animation(
                            .linear(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: false),
                            value: animate
                        )
                }
            }
            .onAppear {
                animate = true
            }
        }
    }
    
    struct ConfettiPiece: View {
        let index: Int
        
        var body: some View {
            Circle()
                .fill([Color.red, .blue, .green, .yellow, .purple, .orange].randomElement() ?? .red)
                .frame(width: 10, height: 10)
                .offset(
                    x: CGFloat.random(in: -200...200),
                    y: CGFloat(index) * 20
                )
                .rotationEffect(.degrees(Double.random(in: 0...360)))
        }
    }
    
    var cameraView: some View {
        GeometryReader { geometry in
            ZStack {
                // Base camera layer
                ZStack {
                    CameraPreview(camera: camera)
                        .ignoresSafeArea()
                    
                    if showFlash {
                        Color.white
                            .opacity(0.7)
                            .ignoresSafeArea()
                            .transition(.opacity)
                    }
                    
                    // Photo review image - replaces camera when reviewing or identifying
                    if (isReviewingPhoto || isIdentifying), let image = capturedImage {
                        Color.black
                            .ignoresSafeArea()
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .clipped()
                            .ignoresSafeArea()
                    }
                }
                
                // Capture frame overlay
                if showCaptureFrame && !isIdentifying && !isReviewingPhoto {
                    GeometryReader { frameGeometry in
                        let frameWidth = frameGeometry.size.width * 0.82
                        let frameHeight = frameGeometry.size.height * 0.64
                        let cornerLength: CGFloat = 28
                        let cornerThickness: CGFloat = 3.5
                        let frameX = frameGeometry.size.width / 2
                        let frameY = (frameGeometry.size.height / 2) - 30
                        
                        // Top-left corner
                        Path { path in
                            path.move(to: CGPoint(x: frameX - frameWidth/2, y: frameY - frameHeight/2 + cornerLength))
                            path.addLine(to: CGPoint(x: frameX - frameWidth/2, y: frameY - frameHeight/2))
                            path.addLine(to: CGPoint(x: frameX - frameWidth/2 + cornerLength, y: frameY - frameHeight/2))
                        }
                        .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: cornerThickness, lineCap: .round, lineJoin: .round))
                        
                        // Top-right corner
                        Path { path in
                            path.move(to: CGPoint(x: frameX + frameWidth/2 - cornerLength, y: frameY - frameHeight/2))
                            path.addLine(to: CGPoint(x: frameX + frameWidth/2, y: frameY - frameHeight/2))
                            path.addLine(to: CGPoint(x: frameX + frameWidth/2, y: frameY - frameHeight/2 + cornerLength))
                        }
                        .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: cornerThickness, lineCap: .round, lineJoin: .round))
                        
                        // Bottom-left corner
                        Path { path in
                            path.move(to: CGPoint(x: frameX - frameWidth/2, y: frameY + frameHeight/2 - cornerLength))
                            path.addLine(to: CGPoint(x: frameX - frameWidth/2, y: frameY + frameHeight/2))
                            path.addLine(to: CGPoint(x: frameX - frameWidth/2 + cornerLength, y: frameY + frameHeight/2))
                        }
                        .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: cornerThickness, lineCap: .round, lineJoin: .round))
                        
                        // Bottom-right corner
                        Path { path in
                            path.move(to: CGPoint(x: frameX + frameWidth/2 - cornerLength, y: frameY + frameHeight/2))
                            path.addLine(to: CGPoint(x: frameX + frameWidth/2, y: frameY + frameHeight/2))
                            path.addLine(to: CGPoint(x: frameX + frameWidth/2, y: frameY + frameHeight/2 - cornerLength))
                        }
                        .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: cornerThickness, lineCap: .round, lineJoin: .round))
                    }
                    .ignoresSafeArea()
                }
                
                if isIdentifying {
                    ScanningOverlay()
                }
                
                if !identifiedCar.isEmpty && !isIdentifying {
                    CelebrationView(
                        carName: identifiedCar,
                        category: carCategory,
                        points: earnedPoints,
                        onScanAnother: {
                            identifiedCar = ""
                            capturedImage = nil
                            showCaptureFrame = true
                        },
                        onViewCollection: {
                            presentationMode.wrappedValue.dismiss()
                            // Post notification to switch to Collection tab
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                NotificationCenter.default.post(name: NSNotification.Name("SwitchToCollectionTab"), object: nil)
                            }
                        }
                    )
                }
                
                // Not a car alert
                if showNotCarAlert {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.red)
                            
                            Text("Car not identified")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text("Please take a photo of a car")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                showNotCarAlert = false
                                capturedImage = nil
                                showCaptureFrame = true
                            }) {
                                Text("OK")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 120)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(15)
                            }
                            .padding(.top, 10)
                        }
                        .padding(40)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(25)
                        .padding(40)
                    }
                }
                
                // Exit button - positioned with absolute coordinates
                if !isIdentifying && identifiedCar.isEmpty {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .position(x: 38, y: 70)
                    .zIndex(100)
                }
                
                // Bottom buttons - positioned at the bottom
                if !isIdentifying && identifiedCar.isEmpty {
                    VStack {
                        Spacer()
                        
                        if isReviewingPhoto {
                            HStack(spacing: 40) {
                                // Retake button
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isReviewingPhoto = false
                                        capturedImage = nil
                                        showCaptureFrame = true
                                    }
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.system(size: 28))
                                            .foregroundColor(.white)
                                        
                                        Text("Retake")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                // Identify button
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isReviewingPhoto = false
                                        isIdentifying = true
                                        if let image = capturedImage {
                                            identifyCarWithGemini(image: image)
                                        }
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Text("Identify")
                                            .font(.system(size: 18, weight: .semibold))
                                        
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 18, weight: .semibold))
                                    }
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 15)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                }
                            }
                            .padding(.bottom, 40)
                        } else if showCaptureFrame {
                            Button(action: capturePhoto) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                        .frame(width: 80, height: 80)
                                    
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 65, height: 65)
                                }
                            }
                            .padding(.bottom, 80)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func capturePhoto() {
        // Hide capture frame and button immediately (no animation)
        showCaptureFrame = false
        
        // Instantaneous flash effect
        showFlash = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            showFlash = false
        }
        
        camera.takePicture { image in
            if let image = image {
                capturedImage = image
                // Show review screen instead of immediately identifying
                withAnimation(.easeInOut(duration: 0.3)) {
                    isReviewingPhoto = true
                }
            }
        }
    }
    
    func identifyCarWithGemini(image: UIImage) {
        let apiKey = "AIzaSyBgWTL2l7PECw50GC2yaE5t3odm2Nqoa78"
        let model = "gemini-2.0-flash-exp"
        
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8),
              let base64Image = imageData.base64EncodedString() as String? else {
            isIdentifying = false
            return
        }
        
        let prompt = """
        You are an expert automotive identification AI with deep knowledge of all vehicle makes and models.

        IMPORTANT: First, determine if this image contains a CAR (automobile, vehicle with 4 wheels designed for road transportation).
        
        If the image does NOT contain a car (e.g., it's a person, building, animal, motorcycle, bicycle, truck, bus, or any other non-car object), respond with ONLY the word: NOT_A_CAR
        
        If the image DOES contain a car, analyze it carefully and identify:
        1. The exact make (manufacturer)
        2. The specific model name and variant
        3. The body style (sedan, coupe, SUV, roadster, convertible, etc.)
        4. The approximate year or generation

        Pay special attention to:
        - Headlight and taillight design
        - Grille shape and badging
        - Body lines and proportions
        - Wheel design
        - Unique aerodynamic features
        - Convertible top or roof type (if applicable)
        - Side vents, intakes, and body styling

        Be as specific as possible about the variant (Sport, Premium, GT, AMG, M, RS, Type R, etc.)

        Distinguish between similar models by analyzing key design differences.

        Respond with only: [Year Range] [Make] [Model] [Variant] [Body Style]
        
        Do NOT include Year Range IF unknown.

        Example: 2017-2022 Lamborghini Aventador S Roadster
        Example: 2020-2023 Toyota Camry XSE Sedan
        Example: 2021-2024 BMW M3 Competition
        
        Remember: If it's NOT a car, respond with: NOT_A_CAR
        """
        
        let requestBody: [String: Any] = [
            "contents": [[
                "parts": [
                    ["text": prompt],
                    ["inline_data": ["mime_type": "image/jpeg", "data": base64Image]]
                ]
            ]],
            "generationConfig": [
                "temperature": 0.4,
                "maxOutputTokens": 50
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isIdentifying = false
                
                guard let data = data, error == nil else {
                    self.identifiedCar = "Network Error"
                    return
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        self.identifiedCar = "Error: Invalid JSON"
                        return
                    }
                    
                    if let error = json["error"] as? [String: Any],
                       let message = error["message"] as? String {
                        self.identifiedCar = "API Error: \(message)"
                        return
                    }
                    
                    guard let candidates = json["candidates"] as? [[String: Any]],
                          let content = candidates.first?["content"] as? [String: Any],
                          let parts = content["parts"] as? [[String: Any]],
                          let text = parts.first?["text"] as? String else {
                        self.identifiedCar = "Error: Could not parse"
                        return
                    }
                    
                    let carName = text
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .replacingOccurrences(of: "\n", with: " ")
                    
                    // Check if it's not a car
                    if carName.uppercased().contains("NOT_A_CAR") || carName.uppercased() == "NOT_A_CAR" {
                        self.showNotCarAlert = true
                        return
                    }
                    
                    self.identifiedCar = carName
                    
                    // Save the car to Firestore
                    if let capturedImage = self.capturedImage {
                        self.saveCar(name: carName, image: capturedImage)
                    }
                    
                } catch {
                    self.identifiedCar = "Parse Error"
                }
            }
        }.resume()
    }
    
    func saveCar(name: String, image: UIImage) {
        print("💾 Starting to save car: \(name)")
        
        // Categorize the car first
        categorizeCarWithGemini(carName: name) { category in
            // Store category and points in state for celebration view
            self.carCategory = category
            self.earnedPoints = self.pointsForCategory(category)
            
            let db = Firestore.firestore()
            let storage = Storage.storage()
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("❌ Failed to convert image to data")
                return
            }
            
            print("✅ Image converted to data, size: \(imageData.count) bytes")
            print("🏷️ Car categorized as: \(category.rawValue)")
            
            let imageRef = storage.reference().child("car_images/\(UUID().uuidString).jpg")
            
            print("📤 Uploading image to Firebase Storage...")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    print("❌ Image upload failed: \(error.localizedDescription)")
                    return
                }
                
                print("✅ Image uploaded successfully")
                
                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("❌ Failed to get download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let downloadURL = url else {
                        print("❌ Download URL is nil")
                        return
                    }
                    
                    print("✅ Got download URL: \(downloadURL.absoluteString)")
                    
                    // Calculate points based on category
                    let points = self.pointsForCategory(category)
                    
                    let carData: [String: Any] = [
                        "name": name,
                        "imageURL": downloadURL.absoluteString,
                        "dateCaptured": Timestamp(date: Date()),
                        "points": points,
                        "category": category.rawValue
                    ]
                    
                    print("📤 Saving to Firestore with data: \(carData)")
                    
                    db.collection("cars").addDocument(data: carData) { error in
                        if let error = error {
                            print("❌ Firestore save failed: \(error.localizedDescription)")
                        } else {
                            print("✅ Car saved successfully to Firestore with category: \(category.rawValue) and points: \(points)!")
                        }
                    }
                }
            }
        }
    }
    
    func categorizeCarWithGemini(carName: String, completion: @escaping (CarCategory) -> Void) {
        // First try keyword detection for quick categorization
        if let quickCategory = categorizeByKeywords(carName: carName) {
            print("✅ Quick categorization by keywords: \(quickCategory.rawValue)")
            completion(quickCategory)
            return
        }
        
        // If keywords don't match, use Gemini AI for reasoning
        print("🤖 Using Gemini AI for categorization...")
        
        let apiKey = "geminiAPIKey"
        let model = "gemini-2.0-flash-exp"
        
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        Categorize this car: "\(carName)"
        
        Categories:
        1. Common - Mass-market everyday cars, economy/mainstream brands (Honda Civic, Toyota Camry, Ford F-150)
        2. Uncommon - Premium mainstream, performance variants, entry sports cars (Mazda MX-5, BMW 3 Series, Audi A4)
        3. Rare - Luxury brands, high-performance, $80k-150k range (BMW M3, Porsche 911, Mercedes AMG GT)
        4. Exotic - Exotic supercars, ultra-luxury, $150k-400k (Lamborghini, Ferrari, McLaren)
        5. Legendary - Hypercars, classics, one-of-a-kind, $500k+ (Bugatti, Koenigsegg, classic collectibles)
        
        Respond with ONLY ONE WORD from these options: Common, Uncommon, Rare, Exotic, Legendary
        """
        
        let requestBody: [String: Any] = [
            "contents": [[
                "parts": [
                    ["text": prompt]
                ]
            ]],
            "generationConfig": [
                "temperature": 0.2,
                "maxOutputTokens": 10
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("❌ Gemini categorization failed, defaulting to Common")
                    completion(.common)
                    return
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let candidates = json["candidates"] as? [[String: Any]],
                          let content = candidates.first?["content"] as? [String: Any],
                          let parts = content["parts"] as? [[String: Any]],
                          let text = parts.first?["text"] as? String else {
                        print("❌ Failed to parse Gemini response, defaulting to Common")
                        completion(.common)
                        return
                    }
                    
                    let categoryText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    let category = CarCategory(rawValue: categoryText) ?? .common
                    
                    print("✅ Gemini categorized as: \(category.rawValue)")
                    completion(category)
                    
                } catch {
                    print("❌ Error parsing response, defaulting to Common")
                    completion(.common)
                }
            }
        }.resume()
    }
    
    func categorizeByKeywords(carName: String) -> CarCategory? {
        let name = carName.lowercased()
        
        // Legendary keywords - Hypercars, classics, ultra-rare
        let legendaryKeywords = [
            "bugatti", "koenigsegg", "pagani", "mclaren f1", "ferrari f40", "ferrari f50",
            "ferrari enzo", "ferrari laferrari", "porsche 918", "mclaren p1", "hypercar",
            "hennessey venom", "ssc tuatara", "rimac", "czinger", "gordon murray t.50",
            "aston martin valkyrie", "mercedes amg one", "ferrari 250 gto", "shelby cobra"
        ]
        
        // Exotic keywords - Supercars and ultra-luxury
        let exoticKeywords = [
            "lamborghini", "ferrari 488", "ferrari 458", "ferrari 812", "ferrari roma",
            "ferrari sf90", "mclaren 720s", "mclaren 765lt", "mclaren artura", "mclaren gt",
            "bentley", "rolls-royce", "aston martin", "maserati mc20", "lotus evija",
            "acura nsx", "lexus lfa", "aventador", "huracan", "countach"
        ]
        
        // Rare keywords - Luxury performance and high-end sports
        let rareKeywords = [
            "porsche 911 turbo", "porsche 911 gt3", "porsche 911 gt2", "porsche taycan turbo",
            "bmw m3", "bmw m4", "bmw m5", "bmw m8", "mercedes amg gt", "mercedes amg",
            "audi r8", "audi rs6", "audi rs7", "corvette z06", "corvette zr1",
            "nissan gt-r", "lexus lc", "cadillac ct5-v blackwing", "alfa romeo giulia quadrifoglio",
            "jaguar f-type r", "maserati", "range rover sport sv"
        ]
        
        // Uncommon keywords - Performance variants and premium
        let uncommonKeywords = [
            "bmw m340i", "bmw 4 series", "bmw m240i", "audi s4", "audi s5", "audi s3",
            "mercedes c43", "mercedes e53", "porsche cayman", "porsche boxster",
            "porsche macan", "corvette stingray", "camaro zl1", "camaro ss",
            "mustang gt", "mustang shelby", "challenger srt", "charger srt",
            "mazda mx-5", "miata", "subaru wrx", "subaru sti", "golf r", "golf gti",
            "civic type r", "genesis g70", "genesis g80", "lexus is 350", "infiniti q50"
        ]
        
        // Common keywords - Mass-market vehicles
        let commonKeywords = [
            "civic", "accord", "camry", "corolla", "altima", "sentra", "versa",
            "jetta", "passat", "tiguan", "rav4", "cr-v", "pilot", "highlander",
            "f-150", "silverado", "ram 1500", "tacoma", "ranger", "colorado",
            "escape", "rogue", "equinox", "explorer", "traverse", "pathfinder",
            "fusion", "malibu", "sonata", "elantra", "forte", "optima", "soul"
        ]
        
        // Check in order from highest to lowest rarity
        for keyword in legendaryKeywords {
            if name.contains(keyword) {
                return .legendary
            }
        }
        
        for keyword in exoticKeywords {
            if name.contains(keyword) {
                return .exotic
            }
        }
        
        for keyword in rareKeywords {
            if name.contains(keyword) {
                return .rare
            }
        }
        
        for keyword in uncommonKeywords {
            if name.contains(keyword) {
                return .uncommon
            }
        }
        
        for keyword in commonKeywords {
            if name.contains(keyword) {
                return .common
            }
        }
        
        // Return nil if no keywords match, so Gemini can be used
        return nil
    }
    
    func pointsForCategory(_ category: CarCategory) -> Int {
        switch category {
        case .common: return 10
        case .uncommon: return 25
        case .rare: return 50
        case .exotic: return 100
        case .legendary: return 250
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.bounds
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        DispatchQueue.global(qos: .userInitiated).async {
            camera.session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            camera.preview.frame = uiView.bounds
        }
    }
}

class CameraModel: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    var preview = AVCaptureVideoPreviewLayer()
    
    var completionHandler: ((UIImage?) -> Void)?
    var readyCallback: (() -> Void)?
    
    func checkPermissions(onReady: @escaping () -> Void) {
        self.readyCallback = onReady
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                } else {
                    DispatchQueue.main.async {
                        onReady()
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                onReady()
            }
        }
    }
    
    func setupCamera() {
        do {
            session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                readyCallback?()
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.readyCallback?()
                }
            }
        } catch {
            readyCallback?()
        }
    }
    
    func takePicture(completion: @escaping (UIImage?) -> Void) {
        self.completionHandler = completion
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            completionHandler?(nil)
            return
        }
        
        if let imageData = photo.fileDataRepresentation(),
           let image = UIImage(data: imageData) {
            completionHandler?(image)
        } else {
            completionHandler?(nil)
        }
    }
}

#Preview {
    CustomCameraView()
}
