//
//  ParseClient.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/11/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    class func shared() -> ParseClient {
        struct Singleton {
            static var instance = ParseClient()
        }
        return Singleton.instance
    }
    
    var students: [[String:AnyObject]]?
    var loggedInStudent: Student?
    
    private override init() {}

    func getStudentLocations(completion: @escaping(_ error: String?) -> Void) {
        var urlString: String = Constants.urlString
        urlString.append("?limit=100&order=-updatedAt")
        
        var request = URLRequest.init(url: URL(string:urlString)!)
        request.addValue(Constants.apiKey, forHTTPHeaderField: Constants.apiHeader)
        request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationHeader)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                completion("Error while getting student locations. error: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion("Get student location returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                completion("Data is nil for get student locations")
                return
            }
            
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                self.students = dict["results"] as? [[String:AnyObject]]
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                completion("Json parsing error while fetching student data")
            }
        }
        task.resume()
    }
    
    func getStudentLocationsData(completion: @escaping(_ result:Data?, _ error: String?) -> Void) {
        var urlString: String = Constants.urlString
        urlString.append("?limit=100&order=-updatedAt")
        
        var request = URLRequest.init(url: URL(string:urlString)!)
        request.addValue(Constants.apiKey, forHTTPHeaderField: Constants.apiHeader)
        request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationHeader)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                completion(nil, "Error while getting student locations. error: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil,"Get student location returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                completion(nil, "Data is nil for get student locations")
                return
            }
            
            completion(data, nil)
        }
        task.resume()
    }

    func postStudent(_ current: Student,completionHandler: @escaping( _ result : Data?, _ error : String?) -> Void) {
        var request = URLRequest(url: URL(string: Constants.urlString)!)
        request.httpMethod = "POST"
        request.addValue(Constants.apiKey, forHTTPHeaderField: Constants.apiHeader)
        request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var dict = [String : AnyObject]()
        dict["uniqueKey"] = current.userId as AnyObject
        dict["firstName"] = current.firstName as AnyObject
        dict["lastName"] = current.lastName as AnyObject
        dict["mediaURL"] = current.webURL as AnyObject
        dict["latitude"] = current.coordinate.latitude as AnyObject
        dict["longitude"] = current.coordinate.longitude as AnyObject

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {}
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else {
                completionHandler(nil, "Error while posting student")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil, "Post student request returned a status code other than 2xx!")
                return
            }
            guard let data = data else
            {
                completionHandler(nil, "Could not post student data")
                return
            }
            
            completionHandler(data,nil)
        }
        task.resume()
    }

    func putStudent(_ current: Student, completion: @escaping(_ result : Data? , _ errorString: String?) -> Void)
    {
        var urlString : String = Constants.urlString
        urlString.append(current.objectId)
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(Constants.apiKey, forHTTPHeaderField: Constants.apiHeader)
        request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var dict = [String : AnyObject]()
        dict["uniqueKey"] = current.userId as AnyObject
        dict["firstName"] = current.firstName as AnyObject
        dict["lastName"] = current.lastName as AnyObject
        dict["mediaURL"] = current.webURL as AnyObject
        dict["latitude"] = current.coordinate.latitude as AnyObject
        dict["longitude"] = current.coordinate.longitude as AnyObject
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {}
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else {
                completion(nil,"Error with put student request")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, "Put student request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                completion(nil, "Put student request returned no data")
                return
            }
            
            completion(data,nil)
        }
        task.resume()
    }
    
    struct Constants {
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiHeader = "X-Parse-REST-API-Key"
        static let applicationHeader = "X-Parse-Application-Id"
        static let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/"
    }
}
