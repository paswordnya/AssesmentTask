//
//  BottomSheetView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 07/01/25.
//

import Foundation
import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isPresented: Bool
    @State private var contentHeight: CGFloat = 0
    let content: () -> Content
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                content()
                    .frame(maxWidth: .infinity)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            contentHeight = geometry.size.height
                        }
                    }).padding(.top,20)
                
                Spacer()
            }.padding()
                .frame(maxHeight: .infinity)
                .background(Color.white)// Add top and bottom border
                .cornerRadius(15)
                .presentationDetents([.fraction(min(contentHeight / UIScreen.main.bounds.height, 1.0))])
        } else {
            VStack {
                content()
                    .frame(maxWidth: .infinity)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            contentHeight = geometry.size.height
                        }
                    }).padding(.top,20)
                
                Spacer()
            }.padding()
                .frame(maxHeight: .infinity)
                .background(Color.white)// Add top and bottom border
                .cornerRadius(15)
            
        }
    }
}

struct BootomSheetChoice: View {
    @Binding var isPresented: Bool
    @State var filterItem: [FilterModel]
    @Binding var id:UUID
    @State private var selectedFilter = "" // Menyimpan filter yang dipilih
    @State private var description : String = ""
    let action: (_ title:String, _ status: Int16) -> Void
    var body: some View {
        
        VStack(alignment:.center, spacing: 2){
            Text("Update Progress")
                .font(.headline)
                .foregroundColor(.black).padding(.bottom,20)
                .padding(.top,20)
            
            
            ForEach(filterItem) { filter in
                
                Button(action: {
                    withAnimation{
                        selectedFilter = filter.title
                        action(filter.title, Int16(filter.status))
                        isPresented = false
                    }
                    
                }) {
                    Text(filter.title)
                        .font(.headline)
                        .foregroundColor(selectedFilter == filter.title ? Color.white : Color.black)
                        .padding()
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(selectedFilter == filter.title ? Color.black : Color.white)
                        .cornerRadius(10).overlay(
                            RoundedRectangle(cornerRadius: 10) // Bentuk border (bisa diganti dengan Circle, Rectangle, dll.)
                                .stroke(Color.bgsawitprocolor, lineWidth: 2) // Warna dan lebar border
                        )
                }.padding(.vertical,3)
            }
        }
        .padding(.vertical,20)
        
    }
}


struct BootomSheetConfirmationDelete : View {
    @Binding var id:UUID
    @Binding var fireStoreId:String
    let actionSubmit: (_ id: String,_ filreStoreId: String) -> Void
    let actionCancel: () -> Void
    var body: some View {
        
        VStack(alignment:.center, spacing: 2){
            Text("Confirmation!")
                .font(.title2)
                .bold()
                .foregroundColor(.black)
                .padding(.top,20)
            
            VStack(alignment:.center, spacing: 2){
                Text("Are you sure you want to delete this item?")
                    .lineLimit(nil)
                    .font(.body)
                    .lineLimit(nil) // Allow text to wrap and span multiple lines
                    .multilineTextAlignment(.leading)
                    .padding()
                
                HStack(alignment: .center) {
                    // Cancel Button
                    Button(action: {
                        withAnimation{
                            actionCancel()
                        }
                        
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .padding()
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }.padding(.vertical,3)
                    
                    // Submit Button (Delete)
                    
                    Button(action: {
                        withAnimation{
                            actionSubmit(id.uuidString,fireStoreId)
                        }
                        
                    }) {
                        Text("Delete")
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .padding()
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.bgsawitprocolor)
                            .cornerRadius(10)
                    }.padding(.vertical,3)
                    .padding(.horizontal,10)
                    
                    
                }
            }
            
        }.padding(.bottom,20)
        
    }
}


