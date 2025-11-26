//
//  TireCoinIcon.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/25/25.
//

import SwiftUI

struct TireCoinIcon: View {
    let size: CGFloat
    let shadowRadius: CGFloat
    
    var body: some View {
        ZStack {
            // Outer gold coin circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.88, blue: 0.1),
                            Color(red: 1.0, green: 0.84, blue: 0.0),
                            Color(red: 0.85, green: 0.65, blue: 0.0)
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.6), radius: shadowRadius, x: 0, y: 2)
            
            // Inner border
            Circle()
                .stroke(Color(red: 0.7, green: 0.5, blue: 0.0), lineWidth: size * 0.04)
                .frame(width: size * 0.85, height: size * 0.85)
            
            // Tire tread pattern - outer ring
            Circle()
                .stroke(Color(red: 0.6, green: 0.4, blue: 0.0), lineWidth: size * 0.08)
                .frame(width: size * 0.65, height: size * 0.65)
            
            // Tire tread spokes (8 spokes for tire look)
            ForEach(0..<8) { index in
                Rectangle()
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.0))
                    .frame(width: size * 0.04, height: size * 0.3)
                    .offset(y: -size * 0.15)
                    .rotationEffect(.degrees(Double(index) * 45))
            }
            
            // Center hub
            Circle()
                .fill(Color(red: 0.7, green: 0.5, blue: 0.0))
                .frame(width: size * 0.25, height: size * 0.25)
            
            // Center highlight
            Circle()
                .fill(Color(red: 0.85, green: 0.65, blue: 0.0))
                .frame(width: size * 0.15, height: size * 0.15)
                .offset(x: -size * 0.03, y: -size * 0.03)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        TireCoinIcon(size: 60, shadowRadius: 6)
        TireCoinIcon(size: 40, shadowRadius: 4)
        TireCoinIcon(size: 24, shadowRadius: 3)
    }
    .padding()
    .background(Color.white)
}
