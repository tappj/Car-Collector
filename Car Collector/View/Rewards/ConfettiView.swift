//
//  ConfettiView.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/25/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(
                    color: colors.randomElement() ?? .blue,
                    delay: Double.random(in: 0...0.2),
                    duration: Double.random(in: 1.0...2.0),
                    startX: Double.random(in: -200...200),
                    startY: -100,
                    endY: 1000,
                    rotation: Double.random(in: 0...720)
                )
                .opacity(animate ? 0 : 1)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2.0)) {
                animate = true
            }
        }
    }
}

struct ConfettiPiece: View {
    let color: Color
    let delay: Double
    let duration: Double
    let startX: Double
    let startY: Double
    let endY: Double
    let rotation: Double
    
    @State private var yOffset: Double = 0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .offset(x: startX, y: yOffset)
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                withAnimation(
                    .easeOut(duration: duration)
                    .delay(delay)
                ) {
                    yOffset = endY
                    rotationAngle = rotation
                }
            }
    }
}
