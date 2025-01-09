//
//  AddTaskView.swift
//  SawitPro
//
//  Created by Rakka Purnama on 03/01/25.
//

import SwiftUI
import CoreData

struct AddNewTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var addNewTaskViewModel = AddNewTaskViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var priority: String = ""
    @State private var assign: String = "-"
    @State private var colorName: String = "White"
    @State private var title: String = ""
    @State private var description : String = ""
    @State private var dueDate : String = ""
    @State private var errorMessage: String? // To display validation errors
    @State private var isFormSubmitted: Bool = false // Track form submission
    @State var currentTime = Date()
    private let jakartaTimeZone = TimeZone(identifier: "Asia/Jakarta")!
    
   
    var body: some View {
        NavigationView{
            ZStack{
                VStack(alignment: .leading ,spacing:12){
                    ToolBarComponentView(title:"Add New Task",action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    ScrollView{
                        VStack(alignment: .leading ,spacing:12){
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Title")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                TextField("Enter text", text: $title)
                                    .componentTextFieldUndeline()
                            }
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Description")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextEditor(text: $description)
                                    .componentTextAreaUndeline()
                                    .frame(height: 100)
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                
                                HStack(spacing: 8) {
                                    DatePicker("Due Date", selection: $currentTime)
                                    Spacer()
                                    Image(systemName: "calendar.badge.clock")
                                        .foregroundColor(Color.bgsawitprocolor)
                                        .padding(.trailing, 10)
                                }.padding(.vertical,5)
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color(.systemGray4))
                                    .padding(.vertical, 4)
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Priority")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(priority)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                FilterView(filterItem: addNewTaskViewModel.filtersPriority, action: {title,status in
                                    priority = title
                                    
                                })
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Assignment")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(assign)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                HStack(alignment: .top) {
                                    ForEach(addNewTaskViewModel.assignColor){ item in
                                        Circle()
                                            .fill(Color(item.color))
                                            .frame(width: 25, height: 25)
                                            .onTapGesture {
                                                assign = item.title
                                                colorName = item.color
                                            }
                                    }
                                    
                                }
                                
                            }
                            if let errorMessage = errorMessage {
                                           Text(errorMessage)
                                               .foregroundColor(.red)
                                               .multilineTextAlignment(.center)
                                       }
                        }.frame(maxHeight: .infinity,alignment: .top)
                            .padding()
                        
                       
                    }
                    Button(action: {
                            Task {
                                if validateAndSubmitForm(){
                                    await
                                    addNewTaskViewModel.saveDataTask(title: title, description: description, dueDate: currentTime, priority: priority,colorName: colorName, assignName: assign, context: viewContext)
                                }
                            }
                    }) {
                        Text(!addNewTaskViewModel.isLoading ? "Submit" : "Please Wait")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(!addNewTaskViewModel.isLoading ? Color.bgsawitprocolor : Color.gray)
                            .cornerRadius(10)
                        
                    }
                    .padding()
                    if addNewTaskViewModel.isLoading {
                        LoadingView().frame(width: 80, height: 80)
                    }
                }
                if addNewTaskViewModel.isLoading{
                    LoadingPopupView(message: $addNewTaskViewModel.successMessage)
                }
            }
        }.navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $addNewTaskViewModel.isSuccess) {
            HomeScreenView()
        }
    }
    
    func validateAndSubmitForm() -> Bool{
           errorMessage = nil // Clear previous error
           
           // Title validation
           guard !title.isEmpty else {
               errorMessage = "Title is required."
               return false
           }
           
           // Description validation
           guard !description.isEmpty else {
               errorMessage = "Description is required."
               return false
           }
         
            guard !priority.isEmpty else {
               errorMessage = "Priority cannot be in the past."
                return false
           }
           
           // If all validations pass
           isFormSubmitted = true
           errorMessage = nil
            return true
       }
    
    
}

#Preview {
    AddNewTaskView()
}
