//
//  LoadingView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 06/01/25.
//

import SwiftUI


struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
           ZStack {
               // Outer circle
               Circle()
                   .stroke(
                       Color.pink.opacity(0.5),
                       lineWidth: 30
                   )

               // Animated circle
               Circle()
                   .trim(from: 0.0, to: isAnimating ? 0.7 : 0.0) // Dynamic `to` value
                   .stroke(
                       Color.pink,
                       style: StrokeStyle(
                           lineWidth: 30,
                           lineCap: .round
                       )
                   )
                   .rotationEffect(.degrees(-90))
                   .animation(
                       Animation.linear(duration: 4)
                           .repeatForever(autoreverses: false),
                       value: isAnimating
                   )
           }
           .onAppear {
               isAnimating = true // Start the animation when the view appears
           }.frame(width: 40,height: 40)
    }
}

#Preview {
    LoadingView()
}
