//
//  ScanningOverlayView.swift
//  Car Collector
//
//  Created by GitHub Copilot on 11/18/25.
//

import SwiftUI

struct ScanningOverlayView: View {
    @State private var scanPosition: CGFloat = -200
    @State private var pulseOpacity: Double = 0.3
    @State private var borderOpacity: Double = 0.5
    @State private var gridOpacity: Double = 0.2
    @State private var cornerScale: CGFloat = 0.8
    
    let animationDuration: Double = 2.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark overlay for focus
                Color.black.opacity(0.3)
                
                // Animated grid overlay for 3D effect
                VStack(spacing: 20) {
                    ForEach(0..<10) { _ in
                        Rectangle()
                            .fill(Color.cyan.opacity(gridOpacity))
                            .frame(height: 1)
                    }
                }
                .opacity(gridOpacity)
                
                // Main glowing border with gradient
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .cyan.opacity(0.8),
                                .blue,
                                .purple.opacity(0.8),
                                .blue,
                                .cyan.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .opacity(borderOpacity)
                    .shadow(color: .cyan.opacity(0.6), radius: 15)
                    .shadow(color: .blue.opacity(0.4), radius: 25)
                    .padding(30)
                
                // Inner border for depth
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                    .padding(32)
                
                // Main scanning line with glow
                ZStack {
                    // Glow effect
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .clear,
                                    .cyan.opacity(0.2),
                                    .cyan.opacity(0.6),
                                    .white.opacity(0.8),
                                    .cyan.opacity(0.6),
                                    .cyan.opacity(0.2),
                                    .clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 60)
                        .blur(radius: 8)
                    
                    // Sharp line
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .clear,
                                    .cyan.opacity(0.5),
                                    .white,
                                    .cyan.opacity(0.5),
                                    .clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 3)
                }
                .offset(y: scanPosition)
                
                // Secondary scanning line (delayed)
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                .purple.opacity(0.3),
                                .purple.opacity(0.5),
                                .purple.opacity(0.3),
                                .clear
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 30)
                    .offset(y: scanPosition - 100)
                    .blur(radius: 4)
                
                // Gradient pulse overlay
                Rectangle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                .blue.opacity(pulseOpacity * 0.4),
                                .clear
                            ]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 300
                        )
                    )
                
                // Tech-style corner brackets
                VStack {
                    HStack {
                        ScanCorner(rotation: 0)
                            .scaleEffect(cornerScale)
                        Spacer()
                        ScanCorner(rotation: 90)
                            .scaleEffect(cornerScale)
                    }
                    Spacer()
                    HStack {
                        ScanCorner(rotation: 270)
                            .scaleEffect(cornerScale)
                        Spacer()
                        ScanCorner(rotation: 180)
                            .scaleEffect(cornerScale)
                    }
                }
                .padding(20)
                
                // Scanning status indicators (dots)
                VStack {
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.cyan)
                                .frame(width: 8, height: 8)
                                .opacity(pulseOpacity)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: pulseOpacity
                                )
                        }
                    }
                    .padding(.top, 50)
                    Spacer()
                }
                
                // "SCANNING" text
                VStack {
                    Spacer()
                    Text("SCANNING")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan)
                        .opacity(borderOpacity)
                        .shadow(color: .cyan, radius: 5)
                        .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    func startAnimations() {
        // Main scanning line animation
        withAnimation(
            Animation.linear(duration: animationDuration)
                .repeatForever(autoreverses: false)
        ) {
            scanPosition = UIScreen.main.bounds.height + 200
        }
        
        // Pulse animation
        withAnimation(
            Animation.easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
        ) {
            pulseOpacity = 0.9
        }
        
        // Border glow animation
        withAnimation(
            Animation.easeInOut(duration: 1.8)
                .repeatForever(autoreverses: true)
        ) {
            borderOpacity = 1.0
        }
        
        // Grid fade in/out
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            gridOpacity = 0.6
        }
        
        // Corner scale animation
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            cornerScale = 1.1
        }
    }
}

// Tech-style corner brackets for scanning UI
struct ScanCorner: View {
    let rotation: Double
    
    var body: some View {
        ZStack {
            // Outer glow
            Path { path in
                path.move(to: CGPoint(x: 0, y: 30))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 30, y: 0))
            }
            .stroke(Color.cyan.opacity(0.3), lineWidth: 6)
            .blur(radius: 4)
            
            // Main line
            Path { path in
                path.move(to: CGPoint(x: 0, y: 30))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 30, y: 0))
            }
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [.cyan, .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 2.5
            )
            .shadow(color: .cyan, radius: 8)
        }
        .frame(width: 30, height: 30)
        .rotationEffect(.degrees(rotation))
    }
}

#Preview {
    ZStack {
        Color.black
        ScanningOverlayView()
    }
}
