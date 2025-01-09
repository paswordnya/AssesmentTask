//
//  EmptyStateView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.bgsawitprocolor)
                .padding(.bottom, 20)
            Text("No items available")
                .font(.headline)
                .foregroundColor(Color.bgsawitprocolor)
        }
        .padding()
    }
}
#Preview {
    EmptyStateView()
}
