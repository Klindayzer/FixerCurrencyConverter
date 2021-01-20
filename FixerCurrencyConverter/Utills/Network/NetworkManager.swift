/*
 *	NetworkManager.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import Alamofire

struct NetworkManager: Logger {
    
    // MARK: - Properties
    private let manager: SessionManager
    var shouldLog: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    
    // MARK: - Constructors
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    // MARK: - Exposed Methods
    func process<T: Resultable>(_ buildable: Buildable, type: T.Type, completion: @escaping (ServiceResult<T>) -> Void) {
        
        guard NetworkReachability.shared.isReachable else {
            completion(.failure(ServiceError(code: -1, message: "Make sure your device is connected to the internet.")))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            self.fetch(buildable, type: type, completion: completion)
        }
    }
    
    
    // MARK: - Protected Methods
    private func fetch<T: Resultable>(_ buildable: Buildable,  type: T.Type, shouldRetry: Bool = true, completion: @escaping (ServiceResult<T>) -> Void) {
        
        request(buildable, type: T.self) { (result) in
            
            guard shouldRetry else {
                self.handle(result, completion: completion)
                return
            }
            
            self.handleTokenExpiry(buildable, type: type, result: result, completion: completion) { isTokenExpired in
                if !isTokenExpired {
                    self.handle(result, completion: completion)
                }
            }
        }
    }
    
    private func request<T: Resultable>(_ buildable: Buildable, type: T.Type, completion: @escaping (ServiceResult<T>) -> Void) {
        do {
            let request = try buildable.asURLRequest()
            let dataRequest = manager.request(request).validate()
            dataRequest.responseString { responseString in
                
                let data = responseString.data
                let response = responseString.response
                
                self.log(request)
                self.log(response, data: data)
                
                guard let responseData = data, response != nil else {
                    completion(.failure(ServiceError(code: -1, message: NetworkError.noData.value)))
                    return
                }
                completion(T.result(responseData: responseData))
            }
            
        } catch let exception {
            self.log(error: exception)
            completion(.failure(ServiceError(code: -1, message: exception.localizedDescription)))
        }
    }
    
    private func handle<T: Resultable>(_ result: ServiceResult<T>, completion: @escaping (ServiceResult<T>) -> Void) {
        
        DispatchQueue.main.async {
            completion(result)
        }
    }
}


// MARK: - Token expiry Handling
extension NetworkManager {
    
    private func handleTokenExpiry<T: Resultable>(_ buildable: Buildable, type: T.Type, result: ServiceResult<T>, completion: @escaping (ServiceResult<T>) -> Void, isTokenExpired: (Bool) -> Void) {
        
        switch result {
        case .success(_):
            isTokenExpired(false)
        case .failure(let error):
            guard error.code == 101 || error.code == 102 else {
                isTokenExpired(false)
                return
            }
            
            refreshToken {
                self.fetch(buildable, type: type, shouldRetry: false, completion: completion)
            }
        }
    }
    
    private func refreshToken(completion: @escaping () -> Void) {
        
        // TODO: - Make request for regenerating token
        completion()
    }
}
