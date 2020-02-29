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
    private struct Auth {
        static var sessionId = ""
        static var userId = ""
    }
    
    enum Endpoints {
        static let baseUrl = "https://onthemap-api.udacity.com/v1/"
        
        case login
        case signUp
        case getUserData
        case getStudentLocations
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.baseUrl + "session"
            case .signUp: return "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1563790146333000"
            case .getUserData: return Endpoints.baseUrl + "users/" + Auth.userId
            case .getStudentLocations: return Endpoints.baseUrl + "StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.baseUrl + "StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let request = LoginRequest(username: email, password: password)
        taskForPostRequest(url: Endpoints.login.url, request: request, responseType: LoginResponse.self, skipFirstFiveCharacters: true) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
                AppData.userId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getUserData(completionHandler: @escaping (UserDataResponse?, Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getUserData.url, responseType: UserDataResponse.self, skipFirstFiveCharacters: true, completionHandler: completionHandler)
    }
    
    class func getStudentLocations(completionHandler: @escaping (Bool, Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getStudentLocations.url, responseType: StudentLocationsResponse.self, skipFirstFiveCharacters: false) { data, error in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            
            AppData.studentLocations = data.results
            completionHandler(true, nil)
        }
    }
    
    class func postStudentLocation(studentLocation: StudentLocation, completionHandler: @escaping (Bool, Error?) -> Void) {
        taskForPostRequest(url: Endpoints.postStudentLocation.url, request: studentLocation, responseType: PostStudentLocationResponse.self, skipFirstFiveCharacters: false) { (data, error) in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            
            print("Location saved successfully with object id: \(data.objectId)")
            completionHandler(true, nil)
        }
    }
    
    /*-----------------------------------Helper Functions below-------------------------------------*/
    
    /*
     We need parameter `response: ResponseType.Type` so that we can receive type information from the call regarding the
     generic type `ResponseType`. We need this because in Swift we can't specialize functions by writing them like `taskForGetRequest<MyType>(...)`
     as this syntax is invalid in Swift. So the only way to receive type info is to pass type info as param
     */
    @discardableResult private class func taskForGetRequest<ResponseType: Decodable>(url: URL,
                                                                             responseType: ResponseType.Type,
                                                                             skipFirstFiveCharacters: Bool,
                                                                             completionHandler: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            handleResponse(data: data, error: error, responseType: responseType,
                           skipFirstFiveCharacters: skipFirstFiveCharacters, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
    /*
     We need parameter `response: ResponseType.Type` so that we can receive type information from the call regarding the
     generic type `ResponseType`. We need this because in Swift we can't specialize functions by writing them like `taskForPostRequest<MyType>(...)`
     as this syntax is invalid in Swift. So the only way to receive type info is to pass type info as param
     */
    private class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL,
                                                                                   request: RequestType,
                                                                                   responseType: ResponseType.Type,
                                                                                   skipFirstFiveCharacters: Bool,
                                                                                   completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        //build http body
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            handleResponse(data: data, error: error, responseType: responseType,
                           skipFirstFiveCharacters: skipFirstFiveCharacters,completionHandler: completionHandler)
        }
        task.resume()
    }
    
    private class func handleResponse<ResponseType: Decodable>(data: Data?,
                                                               error: Error?,
                                                               responseType: ResponseType.Type,
                                                               skipFirstFiveCharacters: Bool,
                                                               completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        let callCompletionHandler = { (response: ResponseType?, error: Error?) in
            DispatchQueue.main.async {
                completionHandler(response, error)
            }
        }
        
        guard var data = data else {
            callCompletionHandler(nil, error)
            return
        }
        
        /**
         FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
         These characters are used for security purposes. In the upcoming examples,
         you will see that we subset the response data in order to skip over the first 5 characters.
        */
        if skipFirstFiveCharacters {
            data = data.subdata(in: 5..<data.count)
        }
        let string = String(data: data, encoding: .utf8) ?? "Empty response"
        print("response: " + string)
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
    
    class func logout(completionHandler: ((Bool, Error?) -> Void)? = nil) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
    
        let callCompletionHandler = { (success: Bool, error: Error?) in
            DispatchQueue.main.async {
                completionHandler?(success, error)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            clearUserData()
            guard let data = data else { // Handle error…
                callCompletionHandler(false, error)
                return
            }
            
            let newData = data.subdata(in: 5..<data.count) /* subset response data! */
            print("Logout response: " + String(data: newData, encoding: .utf8)!)
            callCompletionHandler(true, nil)
        }
        task.resume()
    }
    
    private class func clearUserData() {
        Auth.sessionId = ""
        Auth.userId = ""
        AppData.studentLocations.removeAll()
        AppData.userId = ""
    }
}
