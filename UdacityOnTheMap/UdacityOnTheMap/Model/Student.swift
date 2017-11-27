//
//  Student.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/11/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import Foundation
import MapKit

struct Student {
    var firstName: String = ""
    var lastName: String = ""
    var userId: String = ""
    var objectId: String = ""
    var mapString: String = ""
    var webURL: String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var createdAt: String = ""
    var updatedAt: String = ""
    var postedPreviously: Bool = false
    
    init?(fromData: [String:AnyObject]) {
        guard fromData["uniqueKey"] != nil else {
            return nil
        }
        guard fromData["lastName"] != nil else {
            return nil
        }
        guard fromData["latitude"] != nil else {
            return nil
        }
        guard fromData["longitude"] != nil else {
            return nil
        }
        self.init(fromData)
    }
    
    init(_ data : [String:AnyObject]) {
        if let firstName = data["firstName"]
        {
            self.firstName =  firstName as! String
        }
        if let lastName = data["lastName"]
        {
            self.lastName =  lastName as! String
        }
        if let mapString = data["mapString"]
        {
            self.mapString = mapString as! String
        }
        if let webURL = data["mediaURL"]
        {
            self.webURL = webURL as! String
        }
        if let latitude  = data["latitude"], let longitude = data["longitude"]
        {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        }
        if let createdAt  = data["createdAt"]
        {
            self.createdAt = createdAt as! String
        }
        if let updatedAt  = data["updatedAt"]
        {
            self.updatedAt = updatedAt as! String
        }
        if let objectId  = data["objectId"]
        {
            self.objectId = objectId as! String
        }
        if let userId  = data["uniqueKey"]
        {
            self.userId = userId as! String
        }
    }
}
