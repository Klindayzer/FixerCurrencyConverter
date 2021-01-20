/*
 *	NetworkReachability.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */


import Alamofire

protocol NetworkAvailableDelegate: AnyObject {
    func onNetworkChange(isReachable: Bool)
}

final class NetworkReachability {
    
    // MARK: - Properties
    static let shared = NetworkReachability()
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    weak var delegate: NetworkAvailableDelegate?
    
    var isReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    
    // MARK: - Constructors
    private init() {}
    
    
    // MARK: - Exposed Methods
    func startNetworkReachabilityObserver() {
        
        reachabilityManager?.listener = { [weak self] status in
            
            var isReachable: Bool {
                switch status {
                case .reachable: return true
                default: return false
                }
            }
            self?.delegate?.onNetworkChange(isReachable: isReachable)
        }
        reachabilityManager?.startListening()
    }
}
