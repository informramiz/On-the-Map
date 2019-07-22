//
//  OnTheMapClient.swift
//  OntheMap
//
//  Created by Apple on 22/07/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation

class OnTheMapClient {
    //as this app does not support persistence so below struct will be used
    struct Auth {
        static var sessionId = ""
        static var userId = ""
    }
    
    enum Endpoints {
        static let baseUrl = "https://onthemap-api.udacity.com/v1"
        
        case login
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.baseUrl + "session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    /*
     We need parameter `response: ResponseType.Type` so that we can receive type information from the call regarding the
     generic type `ResponseType`. We need this because in Swift we can't specialize functions by writing them like `taskForGetRequest<MyType>(...)`
     as this syntax is invalid in Swift. So the only way to receive type info is to pass type info as param
     */
    @discardableResult class func taskForGetRequest<ResponseType: Decodable>(url: URL,
                                                                             responseType: ResponseType.Type,
                                                                             completionHandler: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            handleResponse(data: data, error: error, responseType: responseType, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
    /*
     We need parameter `response: ResponseType.Type` so that we can receive type information from the call regarding the
     generic type `ResponseType`. We need this because in Swift we can't specialize functions by writing them like `taskForPostRequest<MyType>(...)`
     as this syntax is invalid in Swift. So the only way to receive type info is to pass type info as param
     */
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL,
                                                                                   request: RequestType,
                                                                                   responseType: ResponseType.Type,
                                                                                   completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        //build http body
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            handleResponse(data: data, error: error, responseType: responseType, completionHandler: completionHandler)
        }
        task.resume()
    }
    
    private class func handleResponse<ResponseType: Decodable>(data: Data?,
                                                               error: Error?,
                                                               responseType: ResponseType.Type,
                                                               completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        let callCompletionHandler = { (response: ResponseType?, error: Error?) in
            DispatchQueue.main.async {
                completionHandler(response, error)
            }
        }
        
        guard let data = data else {
            callCompletionHandler(nil, error)
            return
        }
        
        do {
            let response = try JSONDecoder().decode(ResponseType.self, from: data)
            callCompletionHandler(response, nil)
        } catch {
            handleError(data, callCompletionHandler)
        }
    }
    
    private class func handleError<ResponseType: Decodable>(_ data: Data,
                                                            _ callCompletionHandler: (ResponseType?, Error?) -> ()) {
        //try parsing the error to TMDB error object
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            callCompletionHandler(nil, errorResponse)
        } catch {
            callCompletionHandler(nil, error)
        }
    }
}
