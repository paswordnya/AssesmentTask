//
//  LoadingPopupView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import SwiftUI

struct LoadingPopupView: View {
    @State private var isLoading = true
    @Binding var message: String
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            // Popup content
            VStack(alignment: .center, spacing: 16) {
                ProgressView() // Default loading spinner
                    .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                    .scaleEffect(1.5) // Scale up the spinner
                
                Text("Loading... \n\("Waiting Delete Task")")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .font(.headline)
            }
            .frame(width: 200, height: 150)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 8)
        }
        .opacity(isLoading ? 1 : 0) // Hide or show the popup
        .animation(.easeInOut(duration: 0.3), value: isLoading)
    }
}


