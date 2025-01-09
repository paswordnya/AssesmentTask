//
//  SaveAddNewTaskModel.swift
//  SawitPro
//
//  Created by Rakka Purnama on 04/01/25.
//

import Foundation

struct TaskModel: Codable{
    var idFirestore: String? = nil
    var title: String
    var descriptions: String
    var dueDate: String
    var priority: String
    var colorName: String
    var assignName: String
    var createAt: String
    var id: String
    var status: Int = 0
    
}

struct TaskHistoryModel : Codable{
    var idFirestore: String? = nil
    var id: String
    var idTask: String
    var status: Int16
    var updateAt: String
}

struct TaskModelResponse: Identifiable{
    var idFirestore: String
    var title: String
    var descriptions: String
    var dueDate: String
    var priority: String
    var colorName: String
    var assignName: String
    var createAt: String
    var id: String
    var status: Int = 0
    
    // Initializer for Core Data
    init(taskEntity: TaskEntity) {
        self.idFirestore = taskEntity.idFirestore ?? ""  // Assuming Firestore ID is stored
        self.id = taskEntity.id?.uuidString ?? ""        // UUID from Core Data
        self.title = taskEntity.title ?? ""
        self.descriptions = taskEntity.descriptions ?? ""
        self.dueDate = taskEntity.duedate  ?? ""
        self.priority = taskEntity.priority ?? ""
        self.colorName = taskEntity.colorName ?? ""
        self.assignName = taskEntity.assignName ?? ""
        self.createAt = taskEntity.createAt ?? ""
        self.status = Int(taskEntity.status)
    }
    
    init(idFirestore: String, data: [String: Any]) {
        
        self.idFirestore = idFirestore
        self.title = data["title"] as? String ?? ""
        self.descriptions = data["descriptions"] as? String ?? ""
        self.dueDate = data["dueDate"] as? String ?? ""
        self.priority = data["priority"] as? String ?? ""
        self.colorName = data["colorName"] as? String ?? ""
        self.assignName = data["assignName"] as? String ?? ""
        self.createAt = data["createAt"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.status = data["status"] as? Int ?? 0
    }
}

struct TaskHistoryModelResponse: Identifiable{
    var idFirestore: String
    var id: String
    var idTask: String
    var status: Int16
    var updateAt: String

    init(historyTaskEntity: HistoryTaskEntity){
        self.idFirestore = historyTaskEntity.idFirestore ?? ""
        self.id = historyTaskEntity.id?.uuidString ?? ""
        self.idTask = historyTaskEntity.idTask?.uuidString ?? ""
        self.status = historyTaskEntity.status
        self.updateAt = historyTaskEntity.updateAt  ?? ""
    }
    
    init(idFirestore: String,data: [String: Any]) {
        self.idFirestore = data["idFirestore"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.idTask = data["idTask"] as? String ?? ""
        self.status = data["status"] as? Int16 ?? 0
        self.updateAt = data["updateAt"] as? String ?? ""
    }
   
    
}


struct AssignColor: Identifiable {
    let id = UUID()
    let title: String
    let color : String
}
