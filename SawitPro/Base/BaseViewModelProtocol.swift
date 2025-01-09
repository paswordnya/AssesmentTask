//
//  BaseViewModelProtocol.swift
//  SawitPro
//
//  Created by Rakka Purnama on 04/01/25.
//

import Foundation

protocol BaseViewModelProtocol{
    var isLoading: Bool { get set }
    var title: String { get }
    var errorMessage: String { get }
    var successMessage: String { get}
}
