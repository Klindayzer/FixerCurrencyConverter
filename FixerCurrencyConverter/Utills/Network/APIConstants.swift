/*
 *	APIConstants.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

struct APIConstants {
    
    static let baseUrl = "http://data.fixer.io/api"
    static let apiToken = "ce7a7d787e77585c984b23df5a9b1225"
}


enum NetworkError: Error {
    case noData
    case unableToDecode
    
    var value: String {
        switch self {
        case .noData: return .dataUnavailable
        case .unableToDecode: return .unableToDecode
        }
    }
}

enum URLError: Error {
    case urlMalformatted
    
    var value: String {
        switch self {
        case .urlMalformatted: return .invalidURL
        }
    }
}

enum URLRequestError: Error {
    case encodingFailed
    
    var value: String {
        switch self {
        case .encodingFailed: return .unableToDecode
        }
    }
}

extension String {
    static let unknown = "unknown"
    static let invalidURL = "URL is not valid"
    static let unableToDecode = "We could not decode the response."
    static let dataUnavailable = "Response returned with no data to decode."
}
