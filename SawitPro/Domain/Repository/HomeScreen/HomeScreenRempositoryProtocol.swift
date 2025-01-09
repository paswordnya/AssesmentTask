//
//  HomeScreenRempositoryProtocol.swift
//  SawitPro
//
//  Created by Rakka Purnama on 06/01/25.
//

import Foundation
import Combine
import CoreData

protocol HomeScreenRempositoryProtocol{
    func getDataTask(filter: Int, search: String, context: NSManagedObjectContext) -> AnyPublisher<[TaskEntity], Error>
    func updateTask(id: UUID,status: Int16, context: NSManagedObjectContext) -> AnyPublisher<String, Error>
    func updateTaskFireStore(idTask: UUID, idFirestore: String,status:Int) -> AnyPublisher<String, Error>
    func getDataTaskFireStore(filter: Int, search: String) -> AnyPublisher<[TaskModelResponse], Error>
    func deleteTaskEntityFireStore(documentID: String) -> AnyPublisher<String, Error>
    func deleteHistoryTaskEntityFireStore(idTask: String) -> AnyPublisher<String, Error>
    func deleteTaskById(id: UUID, context: NSManagedObjectContext) -> AnyPublisher<String, Error>
    func deleteTasHistorykById(taskId: UUID, context: NSManagedObjectContext) -> AnyPublisher<String, Error>
}
