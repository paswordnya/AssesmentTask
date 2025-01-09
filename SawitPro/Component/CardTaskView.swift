//
//  CardTaskView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import SwiftUI


struct CardTaskView: View {
    @Binding var id: UUID
    @Binding var idFirestore: String
    @Binding var isSheetPresented: Bool
    @Binding var taskItem: [TaskModelResponse]
    @Binding var iSDetail: Bool
    @Binding var isSheetPresentedDelete: Bool
    var body: some View {
        ForEach(taskItem) { item in
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 5) {
                    VStack(alignment: .leading,spacing: 2){
                        Text(item.title.capitalized)
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color(textColor(colorName: item.colorName)))
                        Text(item.descriptions.capitalized)
                            .font(.caption)
                            .foregroundColor(Color(textColor(colorName: item.colorName)))
                            .padding(.bottom,18)
                    }
                    Spacer()
                    VStack{
                        if item.status != 4{
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(textColor(colorName: item.colorName)))
                                .onTapGesture {
                                    isSheetPresented = true
                                    id = UUID(uuidString: item.id) ?? UUID()
                                    idFirestore = item.idFirestore
                                }.padding(.top,20)
                        }
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(textColor(colorName: item.colorName)))
                            .onTapGesture {
                                isSheetPresentedDelete = true
                                id = UUID(uuidString: item.id) ?? UUID()
                                idFirestore = item.idFirestore
                            }
                            
                    }
                }
                
                
                HStack{
                    VStack(alignment: .leading,spacing:12){
                        Label("\(statusTask(code: Int(item.status)))", systemImage: "rectangle.and.hand.point.up.left")
                            .font(.caption)
                            .foregroundColor(Color(textColor(colorName: item.colorName)))
                        Label("\(item.dueDate)", systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(Color(textColor(colorName: item.colorName)))
                        Label(convertColor(item.colorName), systemImage: "person.bust.circle")
                            .font(.caption)
                            .foregroundColor(Color(textColor(colorName: item.colorName)))
                        Label("Priority \(item.priority)", systemImage: "exclamationmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(Color(textColor(colorName: item.colorName)))
                        
                    }
                    Spacer()
                    if !iSDetail{
                        NavigationLink(destination: TaskDetailView(idTask: .constant(UUID(uuidString: item.id) ?? UUID()), idFireStore: $idFirestore)) {
                            Text("Detail")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 20)
                                .background(getFriorityStatusColor(priorty: item.priority))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(item.colorName))
            .cornerRadius(15)
            .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding([.horizontal, .bottom],12)
        }
    }
    
    func convertColor(_ colorName: String)-> String{
        let assignColor: [AssignColor] = [
            AssignColor(title: "iOS", color: "BlueElectric"),
            AssignColor(title: "Android", color: "GreenMint"),
            AssignColor(title: "Backeend", color: "Ochid"),
            AssignColor(title: "FrontEnd", color: "Orange"),
            AssignColor(title: "DevOps", color: "Red"),
            AssignColor(title: "InfoSec", color: "Black"),
        ]
        for itemColor in assignColor {
            if itemColor.color == colorName {
                return itemColor.title
            }
        }
        return "iOS"
    }
    
    func textColor(colorName : String) -> String {
        var color = "Black"
        switch colorName{
        case "Red":
            color = "White"
            break
        case "White":
            color = "Black"
            break
        case "Black":
            color = "White"
            break
        default:
            color = "Black"
        }
        return color
    }
    
    func getFriorityStatusColor(priorty:String) -> Color{
        if (priorty == "Low"){
            return Color.gray
        }else if (priorty == "High"){
            return Color.yellow
        }else if (priorty == "Normal"){
            return Color.blue
        }
        else if (priorty == "Urgent"){
            return Color.red
        }else{
            return  Color.gray
        }
    }
    
    func statusTask(code: Int) -> String {
        var status = "Todo" // Default status
        switch code {
        case 1:
            status = "In Progress"
        case 2:
            status = "Hold"
        case 3:
            status = "Qa Ready"
        case 4:
            status = "Completed"
        default:
            status = "Todo" // Handle kode yang tidak dikenal
        }
        
        return status
    }
    
    
}
