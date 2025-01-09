//
//  AddNewTaskViewModel.swift
//  SawitPro
//
//  Created by Rakka Purnama on 04/01/25.
//

import Foundation
import Combine
import CoreData

class AddNewTaskViewModel: BaseViewModel{
    @Published var isSuccess : Bool = false
    @Published  var filtersPriority: [FilterModel] = [
        FilterModel(title: "Low",color: .gray,status: 0),
        FilterModel(title: "High",color: .yellow,status: 1),
        FilterModel(title: "Normal",color: .blue,status: 2),
        FilterModel(title: "Urgent",color: .red,status: 3),
    ]
    
    @Published var assignColor: [AssignColor] = [
        AssignColor(title: "iOS", color: "BlueElectric"),
        AssignColor(title: "Android", color: "GreenMint"),
        AssignColor(title: "Backeend", color: "Ochid"),
        AssignColor(title: "FrontEnd", color: "Orange"),
        AssignColor(title: "DevOps", color: "Red"),
        AssignColor(title: "InfoSec", color: "Black"),
    ]
    @Published var filtersStatus: [FilterModel] = [
        FilterModel(title: "Todo",color: .gray,status: 0),
    ]
    private let jakartaTimeZone = TimeZone(identifier: "Asia/Jakarta")!
    
    private let addTaskNewProtocol: AddNewTaskRepositoryProtocol
    init(taskFormRepository: AddNewTaskRepositoryProtocol = AddNewTaskRepository()) {
        self.addTaskNewProtocol = taskFormRepository
    }
    
    func saveDataTask(title: String, description: String, dueDate: Date, priority: String,colorName: String, assignName: String, context: NSManagedObjectContext) async {
        let uuID = UUID()
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = jakartaTimeZone
        formatter.dateFormat = "EEEE, yyyy-MM-dd HH:mm:ss" 
        let dueDateConvert = formatter.string(from: dueDate)
        let dateString = formatter.string(from: currentDate)
        let submitDataTask = TaskModel(
            title: title,
            descriptions: description,
            dueDate: dueDateConvert,
            priority: priority,
            colorName: colorName,
            assignName: assignName,
            createAt: dateString,
            id: uuID.uuidString)
        
        let saveData = addTaskNewProtocol.saveNewTask(submitDataTask, context: context)
        await withCheckedContinuation { continuation in
            saveData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.isSuccess = false
                            self.errorMessage = error.localizedDescription
                        case .finished:
                            print("Successfully fetched task!")
                            self.isSuccess = true
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        self.isSuccess = true
                        self.successMessage = result
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }   
    }
    
    
    
}



