//
//  Student.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/11/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import Foundation
import MapKit

class Student {
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
    
    init(_ data : [String:AnyObject])
    {
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
        if let webURL = data["webURL"]
        {
            self.webURL = webURL as! String
        }
        if let coordinate  = data["studentLocation"]
        {
            self.coordinate = coordinate as! CLLocationCoordinate2D
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
        if let userId  = data["userId"]
        {
            self.userId = userId as! String
        }
    }
    
}
