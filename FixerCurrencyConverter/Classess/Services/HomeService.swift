/*
 *	HomeService.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

struct HomeService: Buildable {
    
    // MARK: - Definitions
    enum HomeServiceType {
        case list // To be used when initial currency load
        case base(String) // To be used when selecting base currency
    }
    
    // MARK: - Properties
    private let type: HomeServiceType
    
    
    // MARK: - Constructors
    init(type: HomeServiceType) {
        self.type = type
    }
    
    // MARK: - Overridden Properties
    var proxy: Proxy {
        return .latest
    }
    
    var params: Params? {
        
        switch type {
        case .list:
            return nil
        
        case .base(let code):
            return ["base": code]
        }
    }
}
