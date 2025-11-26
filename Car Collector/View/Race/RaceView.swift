//
//  RaceView.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/25/25.
//

import SwiftUI

struct RaceView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Race")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Compete with other collectors")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                Spacer()
                
                // Coming Soon Content
                VStack(spacing: 24) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "flag.checkered")
                            .font(.system(size: 44))
                            .foregroundColor(.black)
                    }
                    
                    // Text
                    VStack(spacing: 12) {
                        Text("Coming Soon")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Race against other collectors and climb\nthe leaderboards to prove you're the best.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                }
                
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    RaceView()
}
