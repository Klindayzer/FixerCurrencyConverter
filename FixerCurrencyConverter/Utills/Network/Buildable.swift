/*
 *	Buildable.swift
 *	FixerCurrencyConverter
 *
 *	Created by Adham Alkhateeb on 20/01/2021.
 *	Copyright 2021 Fixer. All rights reserved.
 */

import Foundation
import Alamofire


// MARK: - Type
typealias Params = [String: Any]
typealias Headers = [String: String]


// MARK: - Definitions
enum Encoding {
    case json
    case jsonPrettyPrinted
    case url
    case formURL
}

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum HTTPTimeout: Int {
    case fifteen = 15
    case thirty = 30
    case sixty = 60
    case ninty = 90
}

protocol Buildable {
    var headers: Headers { get }
    var params: Params? { get }
    var encoding: Encoding { get }
    var method: HTTPMethodType { get }
    var httpTimeout: HTTPTimeout { get }
    var proxy: Proxy { get }
}

extension Buildable {
    
    private var serverURL: String {
        return APIConstants.baseUrl
    }
    
    var encoding: Encoding {
        return .url
    }
    
    var method: HTTPMethodType {
        return .get
    }
    
    var httpTimeout: HTTPTimeout {
        return .sixty
    }
    
    var headers: Headers {
        
        let headers: Headers = [
            "Content-Type": " application/json-patch+json",
            "accept": "application/json"
        ]
        return headers
    }
    
    var params: Params? {
        return nil
    }
    
    var url: URL? {
        
        // Append access key to all api calls
        var requestParams = params
        requestParams != nil ? (requestParams?["access_key"] = APIConstants.apiToken) : (requestParams = ["access_key": APIConstants.apiToken])
        let urlString = serverURL.proxyPath(proxy, requestParams)
        return URL(string: urlString)
    }
}

extension Buildable {
    
    private var httpMethod: HTTPMethodType {
        return method
    }
    
    private var timeoutInterval: TimeInterval {
        return TimeInterval(httpTimeout.rawValue)
    }
    
    private var parameterEncoding: ParameterEncoding {
        
        switch encoding {
        case .json:
            return JSONEncoding.default
        case .url:
            return URLEncoding.default
        case .formURL:
            return URLEncoding.httpBody
        case .jsonPrettyPrinted:
            return JSONEncoding.prettyPrinted
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        guard let formedURL = url else {
            throw URLError.urlMalformatted
        }
        
        var request = URLRequest(url: formedURL)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = timeoutInterval
        do {
            return try parameterEncoding.encode(request, with: params)
        } catch {
            throw URLRequestError.encodingFailed
        }
    }
}

private extension String {
    
    func proxyPath(_ proxy: Proxy, _ endPoint: Params?) -> String {
        
        var outputString: String = self
        outputString = [outputString, proxy.rawValue].joined(separator: "/").appendParams(endPoint)
        return outputString
    }
    
    func appendParams(_ params: Params?) -> String {
        
        var outputString = self
        if let endPoint = params?.queryParams, !endPoint.isEmpty {
            if endPoint.first == "?" {
                outputString += endPoint
            } else {
                outputString = [outputString, endPoint].joined(separator: "/")
            }
        }
        return outputString
    }
}

private extension Dictionary where Key == String, Value: Any {
    
    var queryParams: String {
        let paramString = compactMap { $0 }.map { "\($0)=\($1)" }.joined(separator: "&")
        return "?\(paramString)"
    }
}
