//
//  TaskDetailViewModel.swift
//  SawitPro
//
//  Created by Rakka Purnama on 07/01/25.
//

import Foundation
import Combine
import CoreData

@MainActor
class TaskDetailViewModel: BaseViewModel{
    @Published var isSuccess: Bool = false
    @Published var itemTaskEntity: [TaskModelResponse] = []
    @Published var historyTaskDetail: [TaskHistoryModelResponse] = []
    @Published var filters: [FilterModel] = [
        FilterModel(title: "Todo",color: .white,status: 0),
        FilterModel(title: "In Progres",color: .white,status: 1),
        FilterModel(title: "Hold",color: .white,status: 2),
        FilterModel(title: "Qa Ready",color: .white,status: 3),
        FilterModel(title: "Done",color: .white,status: 4),
    ]
    private let taskDetailRepoisory: TaskDetailRepositoryProtocol
    init(taskDetailRepoisory: TaskDetailRepositoryProtocol = TaskDetailRepository()) {
        self.taskDetailRepoisory = taskDetailRepoisory
    }

    
    func getDataTaskDetail(_ id: UUID, context: NSManagedObjectContext) async {
        self.isLoading = true
        let getData = taskDetailRepoisory.getDetailTask(id: id, context: context)
        await withCheckedContinuation { continuation in
            getData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            break
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        let taskModels: [TaskModelResponse] = result.map { taskEntity in
                            TaskModelResponse(taskEntity: taskEntity)
                        }
                        self.itemTaskEntity = taskModels
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
        
    }
    
    func getDataTaskDetailFireStore(id: UUID) async {
        self.isLoading = true
        let getData = taskDetailRepoisory.getDataTaskDetailFireStore(id: id)
        await withCheckedContinuation { continuation in
            getData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            break
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        self.itemTaskEntity = result
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
    }
    
    func getDataTaskHistoryFireStore(id: UUID) async {
        self.isLoading = true
        let getData = taskDetailRepoisory.getDataTaskHistoryFireStore(id: id)
        await withCheckedContinuation { continuation in
            getData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            break
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        self.historyTaskDetail = result
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
    }
    
    func getDataTaskDetailHstory(_ id: UUID, context: NSManagedObjectContext) async {
        self.isLoading = true
        let getData = taskDetailRepoisory.getHistoryTask(id: id, context: context)
        await withCheckedContinuation { continuation in
            getData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            break
                        case .finished:
                            print("Successfully fetched task!")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        let taskModels: [TaskHistoryModelResponse] = result.map { taskHistory in
                            TaskHistoryModelResponse(historyTaskEntity: taskHistory)
                        }
                        self.historyTaskDetail = taskModels
                        print("IOSSSS \(result.count)")
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
        
        
    }
    
    func updateTask(_ id: UUID, _ status: Int16, context: NSManagedObjectContext) async {
        self.isLoading = true
        let updateData = taskDetailRepoisory.updateTask(id: id, status: status, context: context)
        await withCheckedContinuation { continuation in
            updateData.receive(on: DispatchQueue.main)
                .sink { completion in
                self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            print("Successfully fetched task!")
                        case .finished:
                            print("Successfully fetched task!111111111")
                            break
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        self.successMessage = "Successfully Update Task"
                        print("Helllp == Update  \(result)")
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
    }
    
    
    func updateTaskFireStore(idTask: UUID, idFireStore: String, status: Int) async {
        self.isLoading = true
        let updateData = taskDetailRepoisory.updateTaskFireStore(idTask: idTask, idFirestore: idFireStore, status: status)
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
                        self.successMessage = "Successfully Update Task"
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
    }
    
    
    
    func deleteTaskEntityFireStore(documentID: String) async{
        self.successMessage = "Waiting Delete Task"
        let delete = taskDetailRepoisory.deleteTaskEntityFireStore(documentID: documentID)
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
                        self.successMessage = "Successfully Delete Task"
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
            }
    }
    
    func deleteHistoryTaskEntityFireStore(taskId : String) async{
        self.successMessage = "Waiting Delete Task"
        let delete = taskDetailRepoisory.deleteHistoryTaskEntityFireStore(idTask: taskId)
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
        self.successMessage = "Waiting Delete Task"
        let delete = taskDetailRepoisory.deleteTaskById(id: taskId, context: context)
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
        self.successMessage = "Waiting Delete Task"
        let delete = taskDetailRepoisory.deleteTasHistorykById(taskId: taskId, context: context)
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
