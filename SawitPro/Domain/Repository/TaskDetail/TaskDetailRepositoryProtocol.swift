//
//  TaskDetailRepositoryProtocol.swift
//  SawitPro
//
//  Created by Rakka Purnama on 06/01/25.
//

import Foundation
import Combine
import CoreData

protocol TaskDetailRepositoryProtocol{
   
    func getDetailTask(id: UUID, context: NSManagedObjectContext) -> AnyPublisher<[TaskEntity], Error>
    func getHistoryTask(id: UUID, context: NSManagedObjectContext) -> AnyPublisher<[HistoryTaskEntity], Error>
    func updateTask(id: UUID,status: Int16, context: NSManagedObjectContext) -> AnyPublisher<String, Error>
    func updateTaskFireStore(idTask:UUID, idFirestore: String,status:Int) -> AnyPublisher<String, Error>
    func getDataTaskDetailFireStore(id: UUID) -> AnyPublisher<[TaskModelResponse], Error>
    func getDataTaskHistoryFireStore(id: UUID) -> AnyPublisher<[TaskHistoryModelResponse], Error>
    
    func deleteTaskEntityFireStore(documentID: String) -> AnyPublisher<String, Error>
    func deleteHistoryTaskEntityFireStore(idTask: String) -> AnyPublisher<String, Error>
    func deleteTaskById(id: UUID, context: NSManagedObjectContext) -> AnyPublisher<String, Error>
    func deleteTasHistorykById(taskId: UUID, context: NSManagedObjectContext) -> AnyPublisher<String, Error>
}
