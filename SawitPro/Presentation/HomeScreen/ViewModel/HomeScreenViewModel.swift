//
//  HomeScreenViewModel.swift
//  SawitPro
//
//  Created by Rakka Purnama on 06/01/25.
//

import Foundation
import CoreData
import SwiftUI

class HomeScreenViewModel: BaseViewModel{
    
    @Published var items: [TaskModelResponse] = []
    @Published var searchQuery: String = ""
    @State var filters: [FilterModel] = [
        FilterModel(title: "Todo",color: .bgsawitprocolor,status: 0),
        FilterModel(title: "In Progres",color: .bgsawitprocolor,status: 1),
        FilterModel(title: "Hold",color: .bgsawitprocolor,status: 2),
        FilterModel(title: "Qa Ready",color: .bgsawitprocolor,status: 3),
        FilterModel(title: "Completed",color: .bgsawitprocolor,status: 4),
    ]
    private let homeScreenRepositoryProtocol : HomeScreenRempositoryProtocol
    init(homeScreenRepository: HomeScreenRempositoryProtocol = HomeScreenRempository()) {
        self.homeScreenRepositoryProtocol = homeScreenRepository
    }

    
    func getDataTask(filter: Int, searchName: String, context: NSManagedObjectContext) async {
        let getData = homeScreenRepositoryProtocol.getDataTask(filter: filter, search: searchName, context: context)
        await withCheckedContinuation { continuation in
            getData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        let taskModels: [TaskModelResponse] = result.map { taskEntity in
                            TaskModelResponse(taskEntity: taskEntity)
                        }
                        self.items = taskModels
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
    }
    
    func getDataTaskFireStore(filter: Int, searchName: String) async {
        let getData = homeScreenRepositoryProtocol.getDataTaskFireStore(filter: filter, search: searchName)
        await withCheckedContinuation { continuation in
            getData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        print("Helllp FireStoreeeee \(result.count)")
                        self.items = result
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
    }
    
    func updateTask(id: UUID, status: Int16, context: NSManagedObjectContext) async {
        self.isLoading = true
        self.successMessage = "Waiting Update Task"
        let updateData = homeScreenRepositoryProtocol.updateTask(id: id, status: status, context: context)
        await withCheckedContinuation { continuation in
            updateData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        print("Helllp  \(result.count)")
                        
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
    }
    
    
    func updateTaskFireStore(idTask: UUID, idFireStore: String, status: Int) async {
        self.isLoading = true
        self.successMessage = "Waiting Update Task"
        let updateData = homeScreenRepositoryProtocol.updateTaskFireStore(idTask: idTask, idFirestore: idFireStore, status: status)
        await withCheckedContinuation { continuation in
            updateData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
    }
    
    func deleteTaskEntityFireStore(documentID: String) async{
        self.isLoading = true
        self.successMessage = "Waiting Delete Task"
        let delete = homeScreenRepositoryProtocol.deleteTaskEntityFireStore(documentID: documentID)
        await withCheckedContinuation { continuation in
            delete.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
            }
    }
    
    func deleteHistoryTaskEntityFireStore(taskId : String) async{
        self.isLoading = true
        self.successMessage = "Waiting Delete Task"
        let delete = homeScreenRepositoryProtocol.deleteHistoryTaskEntityFireStore(idTask: taskId)
        await withCheckedContinuation { continuation in
            delete.receive(on: DispatchQueue.main)
                .sink { completion in
                    self.isLoading = false
                    switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
            }
    }
    
    func deleteTaskEntity(taskId: UUID, context: NSManagedObjectContext) async{
        self.isLoading = true
        self.successMessage = "Waiting Delete Task"
        let delete = homeScreenRepositoryProtocol.deleteTaskById(id: taskId, context: context)
        await withCheckedContinuation { continuation in
            delete.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            
                        case .finished:
                            print("Delete Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        print("Result Delete Successfully fetched task!")
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
            }
    }
    
    func deleteTaskHistoryEntity(taskId: UUID, context: NSManagedObjectContext) async{
        self.isLoading = true
        self.successMessage = "Waiting Delete Task"
        let delete = homeScreenRepositoryProtocol.deleteTasHistorykById(taskId: taskId, context: context)
        await withCheckedContinuation { continuation in
            delete.receive(on: DispatchQueue.main)
                .sink { completion in
                    self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        case .finished:
                            print("Delete Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        print("Result Delete Successfully fetched task!")
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
            }
    }
    
    
    
}
