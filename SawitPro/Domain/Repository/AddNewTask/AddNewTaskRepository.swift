//
//  AddNewTaskRepository.swift
//  SawitPro
//
//  Created by Rakka Purnama on 05/01/25.
//

import Foundation
import Combine
import CoreData
import Firebase


class AddNewTaskRepository: AddNewTaskRepositoryProtocol{
    private let db = Firestore.firestore()
    private let collectionName = "TaskEntity"
    private let collectionHistory = "HistoryTaskEntity"
    
    func saveNewTask(_ saveAddNewTaskModel: TaskModel, context: NSManagedObjectContext) -> AnyPublisher<String, any Error> {
        
        Future<String, Error> { promise in
            let task = TaskEntity(context: context)
            let historyEntity = HistoryTaskEntity(context: context)
            task.title = saveAddNewTaskModel.title
            task.descriptions = saveAddNewTaskModel.descriptions
           
            task.priority = saveAddNewTaskModel.priority
            task.assignName = saveAddNewTaskModel.assignName
            task.colorName = saveAddNewTaskModel.colorName
            task.createAt = saveAddNewTaskModel.createAt
            historyEntity.updateAt = saveAddNewTaskModel.createAt
            task.duedate = saveAddNewTaskModel.dueDate
            var newTask = saveAddNewTaskModel
            task.id = UUID(uuidString: saveAddNewTaskModel.id)
            historyEntity.status = 0
            let uuid = UUID()
            historyEntity.id = UUID(uuidString: saveAddNewTaskModel.id)
            historyEntity.idTask = UUID(uuidString: saveAddNewTaskModel.id)
            var historyData = TaskHistoryModel(id: uuid.uuidString, idTask: saveAddNewTaskModel.id, status: 0, updateAt: saveAddNewTaskModel.createAt)

                do {
                    let taskEntity = self.db.collection(self.collectionName).document() // Generate ID baru
                    let taskHistory = self.db.collection(self.collectionHistory).document() // Menggunakan ID otomatis
                    newTask.idFirestore = taskEntity.documentID
                    historyData.idFirestore = taskHistory.documentID
                    task.idFirestore = taskEntity.documentID
                    historyEntity.idFirestore = taskHistory.documentID
                    if let taskDictionary = newTask.toDictionary() {
                        taskEntity.setData(taskDictionary)
                    }
                    
                    if let taskHistoryDictionary = historyData.toDictionary() {
                        taskHistory.setData(taskHistoryDictionary)
                    }
                   
                    try context.save()
                    promise(.success(("New task saved successfully!")))
                } catch {
                    promise(.failure(error))
                }
                  
        }.eraseToAnyPublisher()
    }
      
}
