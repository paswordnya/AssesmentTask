//
//  SuccessPopupView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import SwiftUI



struct SuccessPopupView: View {
        @Binding var isVisible: Bool
       var message: String
       var duration: TimeInterval = 3.0
       var backgroundColor: Color = .black
       var textColor: Color = .white

       var body: some View {
           VStack {
               if isVisible {
                   HStack {
                       Text(message)
                           .foregroundColor(textColor)
                           .multilineTextAlignment(.center)
                           .padding()
                           .frame(maxWidth: .infinity)
                   }
                   .background(backgroundColor)
                   .cornerRadius(10)
                   .padding(.horizontal, 20)
                   .transition(.move(edge: .bottom).combined(with: .opacity))
                   .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                           withAnimation {
                               isVisible = false
                           }
                       }
                   }
               }
           }
           .animation(.easeInOut, value: isVisible)
    }
    
}

