//
//  AddNewTaskRepositoryProtocol.swift
//  SawitPro
//
//  Created by Rakka Purnama on 05/01/25.
//

import Foundation
import CoreData
import Combine

protocol AddNewTaskRepositoryProtocol{
    func saveNewTask(_ saveAddNewTaskModel : TaskModel, context: NSManagedObjectContext) -> AnyPublisher<String, Error>
}
