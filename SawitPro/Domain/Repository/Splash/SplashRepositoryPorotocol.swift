//
//  SplashRepositoryPorotocol.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import Foundation
import CoreData
import Combine


protocol SplashRepositoryPorotocol{
    func getDataTaskDetailFireStore(context : NSManagedObjectContext) -> AnyPublisher<[TaskModelResponse], Error>
    func getDataTaskHistoryFireStore(context : NSManagedObjectContext) -> AnyPublisher<[TaskHistoryModelResponse], Error>
    func syncTaskEntityRemoteToLocal(taskModelResponse: TaskModelResponse, context : NSManagedObjectContext)
    func syncTaskHistoryEntityRemoteToLocal(taskModelResponse: TaskHistoryModelResponse, context : NSManagedObjectContext)  
}
