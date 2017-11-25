//
//  UdacityClient.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/4/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    var sessionId: String = ""
    var userId: String = ""
    
    class func shared() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func getStudent(_ userId: String, completion: @escaping (_ result: Data?, _ error: String?) -> Void) {
        var studentApiPath = Constants.UdacityStudentApiPath
        studentApiPath.append(userId)
        let studentRequest = URLRequest(url: URL(string: studentApiPath)!)
        let session = URLSession.shared
        let studentTask = session.dataTask(with: studentRequest) { (data, response, error) in
            guard error == nil else {
                completion(nil, "Error with the student request: \(error?.localizedDescription ?? " ")")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode,
                status >= 200 && status <= 299 else {
                    completion(nil, "Student Request status code is bad")
                    return
            }
            guard let data = data else {
                completion(nil, "Student Request returned no data")
                return
            }
            let range = Range(5..<data.count)
            let subData = data.subdata(in: range)
            completion(subData, nil)
        }
        studentTask.resume()
    }
    
    func login(email: String, password: String, completion: @escaping (_ result: Data?, _ error: String?) -> Void) {
        var request = URLRequest.init(url: URL(string: Constants.UdacitySessionApiPath)!)
        request.httpMethod = Constants.UdacityApiMethod
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let fieldsDictionary = NSMutableDictionary()
        fieldsDictionary.setValue(email, forKey: Constants.Username)
        fieldsDictionary.setValue(password, forKey: Constants.Password)
        let udacityDictionary = NSMutableDictionary()
        udacityDictionary.setValue(fieldsDictionary, forKey: Constants.Udacity)
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: udacityDictionary, options: .prettyPrinted)
            request.httpBody = requestData
        } catch {
            completion(nil, "Unexpected error while serializaing login POST data")
            return
        }
        
        let session = URLSession.shared
        let urlTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, "Error with the Login request: \(error?.localizedDescription ?? "")")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode,
                status >= 200 && status <= 299 else {
                    completion(nil, "Login Request status code is bad")
                    return
            }
            guard let data = data else {
                completion(nil, "Login Request returned no data")
                return
            }
            completion(data, nil)
        }
        urlTask.resume()
    }
    
    func logout(completion: @escaping (_ result: Data?, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: Constants.UdacitySessionApiPath)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == Constants.TokenName {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Constants.TokenHeaderName)
        }
        let session = URLSession.shared
        let urlTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, "Error with logout request: \(error?.localizedDescription ?? "")")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode,
                status >= 200 && status <= 299 else {
                    completion(nil, "Logout request status code is bad")
                    return
            }
            guard let data = data else {
                completion(nil, "Logout request returned no data")
                return
            }
            completion(data, nil)
        }
        urlTask.resume()
    }
    
    struct Constants {
        static let UdacitySessionApiPath = "https://www.udacity.com/api/session"
        static let UdacityStudentApiPath = "https://www.udacity.com/api/users/"
        static let UdacityApiMethod = "POST"
        static let Username = "username"
        static let Password = "password"
        static let Udacity = "udacity"
        static let TokenName = "XSRF-TOKEN"
        static let TokenHeaderName = "X-XSRF-TOKEN"
        static let FacebookApiId = "365362206864879"
        static let FacebookUrlScheme = "onthemap"
    }
}
