//
//  SplashScreenUIView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 03/01/25.
//

import SwiftUI

struct SplashScreenView: View {
    @StateObject private var splashViewModel = SplashViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var isActive = false // Untuk navigasi ke layar utama
    @State private var scaleEffect = 0.8 // Efek animasi logo
    
    var body: some View {
        if isActive {
            HomeScreenView()
        } else {
            VStack {
                Image(systemName: "swift") // Ganti dengan logo aplikasi
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.orange)
                    .scaleEffect(scaleEffect)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.2)) {
                            scaleEffect = 1.0
                        }
                    }
                Text("Sawit Pro").font(.system(size: 24, weight: .bold)).foregroundColor(Color.white)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bgsawitprocolor)
                .onAppear {
                    Task{
                        if networkMonitor.isConnected {
                            await splashViewModel.getDataTaskDetailFireStore(context: viewContext)
                        }else{
                            await splashViewModel.getDataTaskHistoryFireStore(context: viewContext)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isActive = true
                        }
                    }
                }
        }
    }
}


#Preview {
    SplashScreenView()
}
