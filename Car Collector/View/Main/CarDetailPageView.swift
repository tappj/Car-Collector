//
//  CarDetailPageView.swift
//  Car Collector
//

import SwiftUI

struct CarDetailPageView: View {
    let car: Car
    @Environment(\.dismiss) var dismiss
    @State private var carImage: UIImage?
    @State private var isLoadingImage = true
    
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
                        // Name
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Car Name")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            Text(car.name)
                                .font(.system(size: 22, weight: .bold))
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
                        
                        Divider()
                        
                        // Points
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Points")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                                HStack(spacing: 6) {
                                    Image(systemName: "star.fill")
                                        .font(.body)
                                        .foregroundColor(.orange)
                                    Text("\(car.points)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.orange.opacity(0.5))
                        }
                        
                        Divider()
                        
                        // Car ID (if available)
                        if let carId = car.id {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("ID")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                                Text(carId)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray.opacity(0.7))
                            }
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
        }
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
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
