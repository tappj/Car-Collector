//
//  ShowcaseView.swift
//  Car Collector
//
//  Created by Jadon Tapp on 11/16/25.
//

import SwiftUI

struct ShowcaseView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Showcase")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Text("Coming Soon!")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ShowcaseView()
}
