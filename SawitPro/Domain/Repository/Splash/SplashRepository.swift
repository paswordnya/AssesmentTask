//
//  SplashRepository.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import Foundation
import Combine
import CoreData
import Firebase

class SplashRepository : SplashRepositoryPorotocol{
    let db = Firestore.firestore()
    private let collectionName = "TaskEntity"
    private let collectionHistory = "HistoryTaskEntity"
    
    
    func getDataTaskDetailFireStore(context : NSManagedObjectContext) -> AnyPublisher<[TaskModelResponse], Error>{
        let subject = PassthroughSubject<[TaskModelResponse], Error>()
        let query = db.collection(self.collectionName)
        query.getDocuments { querySnapshot, error in
            if let error = error {
                subject.send(completion: .failure(error))
            } else if let querySnapshot = querySnapshot {
                
                let tasks = querySnapshot.documents.map { document in
                    TaskModelResponse(idFirestore: document.documentID, data: document.data())
                }
                subject.send(tasks)
                subject.send(completion: .finished)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func getDataTaskHistoryFireStore(context : NSManagedObjectContext) -> AnyPublisher<[TaskHistoryModelResponse], Error>{
        let subject = PassthroughSubject<[TaskHistoryModelResponse], Error>()
        let query = db.collection(self.collectionHistory)
        query.getDocuments { querySnapshot, error in
            if let error = error {
                subject.send(completion: .failure(error))
            } else if let querySnapshot = querySnapshot {
                let tasks = querySnapshot.documents.map { document in
                    TaskHistoryModelResponse(idFirestore: document.documentID, data: document.data())
                }
                
                subject.send(tasks)
                subject.send(completion: .finished)
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func syncTaskEntityRemoteToLocal(taskModelResponse: TaskModelResponse, context : NSManagedObjectContext)   {
        //Future<String, Error> { promise in
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, yyyy-MM-dd HH:mm:ss"
        
        // Add a predicate to find the specific item by id
        let idUUID: UUID = UUID(uuidString: taskModelResponse.id) ?? UUID()
        fetchRequest.predicate = NSPredicate(format: "id == %@", idUUID as CVarArg)
        
        do {
            // Fetch the item
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty{
                guard let itemToUpdate = results.first else {
                    throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Item not found"])
                }
                itemToUpdate.status = Int16(taskModelResponse.status)
                try context.save()
            }else{
                let taskEntity = TaskEntity(context: context)
                taskEntity.id = UUID(uuidString: taskModelResponse.id)
                taskEntity.title = taskModelResponse.title
                taskEntity.descriptions = taskModelResponse.descriptions
                taskEntity.priority = taskModelResponse.priority
                taskEntity.assignName = taskModelResponse.assignName
                taskEntity.colorName = taskModelResponse.colorName
                taskEntity.idFirestore = taskModelResponse.idFirestore
                taskEntity.status = Int16(taskModelResponse.status)
                taskEntity.createAt = taskModelResponse.createAt
                taskEntity.duedate =  taskModelResponse.dueDate
              
                try context.save()
            }
        } catch {
            
        }
        
    }
    
    func syncTaskHistoryEntityRemoteToLocal(taskModelResponse: TaskHistoryModelResponse, context : NSManagedObjectContext)   {
        let fetchRequest: NSFetchRequest<HistoryTaskEntity> = HistoryTaskEntity.fetchRequest()
        let idUUID: UUID = UUID(uuidString: taskModelResponse.id) ?? UUID()
        fetchRequest.predicate = NSPredicate(format: "id == %@", idUUID as CVarArg)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, yyyy-MM-dd HH:mm:ss"
        let historyEntity = HistoryTaskEntity(context: context)
        historyEntity.idTask = UUID(uuidString: taskModelResponse.idTask)
        historyEntity.status = taskModelResponse.status
        historyEntity.updateAt = taskModelResponse.updateAt
        historyEntity.id = UUID(uuidString: taskModelResponse.id)
        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty{
                try context.save()
            }
        } catch {
            
        }
        
    }
    
    
}
