//
//  SplashViewModel.swift
//  SawitPro
//
//  Created by Rakka Purnama on 09/01/25.
//

import Foundation
import CoreData
import Combine


class SplashViewModel: BaseViewModel{
    
    private let splashRepositoryPorotocol : SplashRepositoryPorotocol
    init(splashRepository: SplashRepositoryPorotocol = SplashRepository()) {
        self.splashRepositoryPorotocol = splashRepository
    }
    
    func getDataTaskDetailFireStore(context : NSManagedObjectContext) async{
        let getData = splashRepositoryPorotocol.getDataTaskDetailFireStore(context: context)
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
                        for resultModelEntity in result {
                            self.splashRepositoryPorotocol.syncTaskEntityRemoteToLocal(taskModelResponse: resultModelEntity, context: context)
                        }
                        
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
        
    }
    
    func getDataTaskHistoryFireStore(context : NSManagedObjectContext) async{
        let getData = splashRepositoryPorotocol.getDataTaskHistoryFireStore(context: context)
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
                        for resultModelEntity in result {
                            self.splashRepositoryPorotocol.syncTaskHistoryEntityRemoteToLocal(taskModelResponse: resultModelEntity, context: context)
                        }
                        
                        continuation.resume()  // Continue execution after success
                    }
                    .store(in: &cancellables)
                }
        
    }
    
    
}
    
