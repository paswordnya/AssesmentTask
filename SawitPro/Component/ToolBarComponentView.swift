//
//  ToolBarView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import SwiftUI

struct ToolBarComponentView: View {
    let title:String
    let action: () -> Void
   
    
    var body: some View {
        VStack(spacing:12){
            Text(title).font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading){
                    Button{
                        action()
                    }label: {
                        Image(systemName: "arrow.left").foregroundColor(.primary)
                            .font(.system(size: 24))
                    }
                }
        }.padding([.horizontal, .bottom],12)
    }
}
