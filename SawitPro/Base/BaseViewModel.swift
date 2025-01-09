//
//  BaseViewModel.swift
//  SawitPro
//
//  Created by Rakka Purnama on 04/01/25.
//

import Foundation
import Combine


class BaseViewModel : ObservableObject, BaseViewModelProtocol{
    var cancellables = Set<AnyCancellable>()
    @Published var title: String = ""
    @Published var isLoading: Bool = false
    @Published var errorReseponse = ""
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var isConnected: Bool = true 
    @Published var isCompleted: Bool = false
       
    
}
