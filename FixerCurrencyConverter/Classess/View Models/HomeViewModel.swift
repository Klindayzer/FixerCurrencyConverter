/*
 *	HomeViewModel.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

class HomeViewModel {
    
    // MARK: - Properties
    private let networkManager = NetworkManager()
    private var rates = [String: Double]()
    private(set) var defaultCurrency: Currency? // Will be used for fallback currency
    
    var baseCurrency: Currency? // Will be used to set the base currency to get rates
    var selectedCurrency: Currency? // Will be used for rate calculation
    
    
    // MARK: - Computed Properties
    private var currencyList: [Currency] { // List of currencies (Code + value)
        
        // filter the currency rates by removing the base currency from the list
        return rates.compactMap {
            if $0.key != baseCurrency?.code {
                return Currency(code: $0.key, value: $0.value)
            }
            return nil
        }.sorted(by: { $0.code < $1.code})
    }
    
    var currencyCodes: [String] { // List of currencies (Code Only)
        
        // Returns a list of currency code
        return currencyList.compactMap {
            return $0.code
        }
    }
    
    var itemsCount: Int {
        // returns currency list items count
        return currencyList.count
    }
    
    // MARK: - Exposed Methods
    func loadCurrencies(baseCurrency: Currency?, callback: @escaping APICallback) {
        
        // check if base currency is selected or not
        var type: HomeService.HomeServiceType {
            if let baseCurrency = baseCurrency {
                return .base(baseCurrency.code) // make api call with base currency selected
            }
            return .list // make api call with default base currency selected
        }
        
        networkManager.process(HomeService(type: type), type: Rates.self) { [weak self] response in
            
            switch response {
            case .success(let model):
                self?.extractData(model, callback)
                
            case .failure(let error):
                callback(error)
            }
        }
    }
    
    func item(at index: Int) -> Currency {
        return currencyList[index]
    }
    
    func calculateRate(base: Double, selected: Double) -> Double {
        return base * selected
    }
    
    
    // MARK: - Protected Methods
    private func extractData(_ model: Rates, _ callback: APICallback) {
        
        guard let rates = model.rates,
            let baseCurrency = model.base else {
                callback(ServiceError(code: -1, message: .unknown))
                return
        }
        
        
        let currency = Currency(code: baseCurrency, value: 0)
        self.rates = rates
        self.baseCurrency = currency
        if defaultCurrency == nil { // check if default currency is already initialized
            defaultCurrency = currency
        }
        callback(nil)
    }
}
