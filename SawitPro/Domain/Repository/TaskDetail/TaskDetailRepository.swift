//
//  TaskDetailRepository.swift
//  SawitPro
//
//  Created by Rakka Purnama on 06/01/25.
//

import Foundation
import Combine
import CoreData
import Firebase

class TaskDetailRepository : TaskDetailRepositoryProtocol {
    let db = Firestore.firestore()
    private let collectionName = "TaskEntity"
    private let collectionHistory = "HistoryTaskEntity"
    
  
    
    func getDetailTask(id: UUID, context: NSManagedObjectContext) -> AnyPublisher<[TaskEntity], Error> {
        Future<[TaskEntity], Error> { promise in
                let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        let result = try context.fetch(fetchRequest)
                        promise(.success((result)))
                    } catch {
                        promise(.failure(error)) // Kirim error jika fetch gagal
                    }
            }
            .eraseToAnyPublisher()
    }
    
    func getHistoryTask(id: UUID, context: NSManagedObjectContext) -> AnyPublisher<[HistoryTaskEntity], Error> {
        Future<[HistoryTaskEntity], Error> { promise in
            context.perform {
                let fetchRequest: NSFetchRequest<HistoryTaskEntity> = HistoryTaskEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "idTask == %@", id as CVarArg)
                let sortDescriptor = NSSortDescriptor(key: "updateAt", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                       
                do {
                    let items = try context.fetch(fetchRequest)
                    promise(.success((items)))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    func getDataTaskDetailFireStore(id: UUID) -> AnyPublisher<[TaskModelResponse], Error>{
        let subject = PassthroughSubject<[TaskModelResponse], Error>()
        let query: Query = db.collection(self.collectionName).whereField("id", isEqualTo: id.uuidString)
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
    
    func getDataTaskHistoryFireStore(id: UUID) -> AnyPublisher<[TaskHistoryModelResponse], Error>{
        let subject = PassthroughSubject<[TaskHistoryModelResponse], Error>()
        let query: Query = db.collection(self.collectionHistory).whereField("idTask", isEqualTo: id.uuidString)
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
    
    
    func updateTask(id: UUID,status: Int16, context: NSManagedObjectContext) -> AnyPublisher<String, any Error> {
        Future<String, Error> { promise in
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            let currentTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: currentTime)
            
                // Add a predicate to find the specific item by id
                fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                let historyEntity = HistoryTaskEntity(context: context)
                historyEntity.idTask = id
                historyEntity.status = status
                historyEntity.updateAt = dateString
                historyEntity.id = UUID()
                do {
                    // Fetch the item
                    let results = try context.fetch(fetchRequest)
                    
                    // Ensure there's at least one matching result
                    guard let itemToUpdate = results.first else {
                        throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Item not found"])
                    }
                    
                    // Update the item's properties
                    itemToUpdate.status = status
                    
                    // Save the context
                    try context.save()
                    promise(.success(("Item updated successfully.")))
                
                } catch {
                    promise(.failure(error))
                }
            
        }.eraseToAnyPublisher()
    }
    
    func updateTaskFireStore(idTask:UUID, idFirestore: String,status:Int) -> AnyPublisher<String, Error> {
        let db = Firestore.firestore()
          return Future<String, Error> { promise in
              let uuID = UUID()
              let currentDate = Date()
              let formatter = DateFormatter()
              formatter.dateFormat =  "EEEE, yyyy-MM-dd HH:mm:ss"
              let dateString = formatter.string(from: currentDate)
              var historyData = TaskHistoryModel(id: uuID.uuidString , idTask: idTask.uuidString, status: Int16(status), updateAt: dateString)
              let taskHistory = self.db.collection(self.collectionHistory).document() // Menggunakan ID otomatis
              historyData.idFirestore = taskHistory.documentID
              
              let updatedData: [String: Any] = [
                  "status": status
              ]
              let documentRef = db.collection(self.collectionName).document(idFirestore)
              if let taskHistoryDictionary = historyData.toDictionary() {
                  taskHistory.setData(taskHistoryDictionary)
              }
                documentRef.setData(updatedData, merge: true){ error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(documentRef.documentID))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    func deleteTaskEntityFireStore(documentID: String) -> AnyPublisher<String, Error> {
            Future<String, Error> { promise in
                let docRef = self.db.collection(self.collectionName).document(documentID)

                docRef.delete { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success("Document deleted successfully"))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    func deleteHistoryTaskEntityFireStore(idTask: String) -> AnyPublisher<String, Error> {
           return Future<String, Error> { promise in
               // Query Firestore for documents matching the given idTask
               self.db.collection(self.collectionHistory)
                   .whereField("idTask", isEqualTo: idTask)
                   .getDocuments { snapshot, error in
                       if let error = error {
                           // If an error occurs during the query, return the error
                           promise(.failure(error))
                           return
                       }

                       // Check if documents were found
                       guard let documents = snapshot?.documents, !documents.isEmpty else {
                           // If no documents are found, return a failure
                           promise(.failure(NSError(domain: "FirestoreService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No documents found for idTask: \(idTask)"])))
                           return
                       }

                       // Perform the deletion of each document
                       let deletionGroup = DispatchGroup() // Use DispatchGroup to track multiple deletions
                       var deletionErrors: [Error] = []
                       
                       for document in documents {
                           deletionGroup.enter()
                           // Delete each document
                           document.reference.delete { error in
                               if let error = error {
                                   deletionErrors.append(error)
                               }
                               deletionGroup.leave()
                           }
                       }

                       // Wait for all deletions to complete
                       deletionGroup.notify(queue: .main) {
                           if deletionErrors.isEmpty {
                               // If no errors occurred, return success
                               promise(.success("Successfully deleted \(documents.count) documents with idTask: \(idTask)"))
                           } else {
                               // If there were errors, return the first error
                               promise(.failure(deletionErrors.first!))
                           }
                       }
                   }
           }
           .eraseToAnyPublisher()  // Return the result as AnyPublisher
       }
    
        func deleteTaskById(id: UUID, context: NSManagedObjectContext) -> AnyPublisher<String, Error> {
            return Future<String, Error> { promise in
                let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

                do {
                    let results = try context.fetch(fetchRequest)
                    if let taskToDelete = results.first {
                        // Delete the task from context
                        context.delete(taskToDelete)
                        
                        // Save the context after deletion
                        try context.save()
                        promise(.success("Task with ID \(id) deleted successfully"))
                    } else {
                        // If no task found, return an error
                        promise(.failure(NSError(domain: "CoreDataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task with ID \(id) not found"])))
                    }
                } catch {
                    // Handle errors (e.g., fetch error, save error)
                    promise(.failure(error))
                }
            }
            .eraseToAnyPublisher() // Return the publisher as AnyPublisher
        }
    
    
    func deleteTasHistorykById(taskId: UUID, context: NSManagedObjectContext) -> AnyPublisher<String, Error> {
            return Future<String, Error> { promise in
                // Create a fetch request for the TaskEntity
                let fetchRequest: NSFetchRequest<HistoryTaskEntity> = HistoryTaskEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "idTask == %@", taskId as CVarArg)
                
                do {
                    // Fetch matching records
                    let results = try context.fetch(fetchRequest)
                    
                    // If no records were found, return an error
                    if results.isEmpty {
                        promise(.failure(NSError(domain: "CoreDataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No tasks found with the provided IDs"])))
                        return
                    }

                    // Delete each fetched record
                    for task in results {
                        context.delete(task)
                    }

                    // Save the context after deletion
                    try context.save()
                    promise(.success("\(results.count) tasks deleted successfully"))
                } catch {
                    // If there was an error (fetch or save), return it
                    promise(.failure(error))
                }
            }
            .eraseToAnyPublisher() // Return as an AnyPublisher
        }
}
