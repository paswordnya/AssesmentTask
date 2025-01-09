//
//  TextAreaStyleWithUnderLine.swift
//  SawitPro
//
//  Created by Rakka Purnama on 08/01/25.
//

import SwiftUI

extension View{
    func componentTextFieldUndeline() -> some View {
        modifier(TextAreaStyleWithUnderLine())
    }
    func componentTextAreaUndeline() -> some View {
        modifier(TextAreaStyleWithUnderLine())
    }
}

struct TextAreaStyleWithUnderLine: ViewModifier {
    @FocusState private var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isFocused ? .blue : Color(.systemGray4)) 
                    .padding(.top, 35),
                alignment: .bottom
            ).overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isFocused ? .blue : Color(.systemGray4))
                    .padding(.horizontal, 4)
            }
            .focused($isFocused)
    }
}


