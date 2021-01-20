/*
 *	Resultable.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import Foundation

typealias APICallback = (ServiceError?) -> Void

enum ServiceResult<T: Codable> {
    case success(T)
    case failure(ServiceError)
}

protocol Resultable: Codable {
    
    func result() -> ServiceResult<Self>
    static func result<T: Resultable>(responseData: Data) -> ServiceResult<T>
}

extension Resultable {
    
    func result() -> ServiceResult<Self> {
        return .success(self)
    }
    
    static func result<T: Resultable>(responseData: Data) -> ServiceResult<T> {
        
        do {
            // First check if api returns error and return failure if so
            let systemErrors = try JSONDecoder().decode(APIErrors.self, from: responseData)
            if let success = systemErrors.success,
                !success,
                let error = systemErrors.error {
                let error = ServiceError(code: error.code, message: error.type)
                return .failure(error)
                
            } else {
                // Handle success response and return mapped object
                let object = try JSONDecoder().decode(T.self, from: responseData)
                return object.result()
            }
            
        } catch let exception {
            return .failure(ServiceError(code: -1, message: exception.localizedDescription))
        }
    }
}

struct ServiceError: Error {
    
    let code: Int
    let message: String
    
    init(code: Int, message: String) {
        
        self.code = code
        self.message = message
    }
}
