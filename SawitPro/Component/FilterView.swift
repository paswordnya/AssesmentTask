//
//  FilterView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import SwiftUI

struct FilterModel: Identifiable {
    let id = UUID()
    let title: String
    let color : Color
    let status : Int
}


struct FilterView: View {
    @State var filterItem: [FilterModel]
    @State private var selectedFilter = "Todo" // Menyimpan filter yang dipilih
    
    let action: (_ title:String, _ status: Int) -> Void
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filterItem) { filter in
                        Text(filter.title)
                            .foregroundColor(selectedFilter == filter.title ? Color.white : Color.bgsawitprocolor)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .font(.system(size: 16))
                            .background(selectedFilter == filter.title ? Color.bgsawitprocolor : Color.white)
                            .cornerRadius(20)
                            .onTapGesture {
                                withAnimation{
                                    selectedFilter = filter.title
                                    action(filter.title, filter.status)
                                }
                                
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 22) // Bentuk border (bisa diganti dengan Circle, Rectangle, dll.)
                                    .stroke(Color.bgsawitprocolor, lineWidth: 2) // Warna dan lebar border
                            )
                        
                    }
                }
                .padding()
            }
            
        }.onAppear(){
            selectedFilter = "Todo"
        }
    }
}




