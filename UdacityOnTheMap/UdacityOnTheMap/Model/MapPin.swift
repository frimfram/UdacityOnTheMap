//
//  MapPin.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/19/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import MapKit

class MapPin : NSObject, MKAnnotation
{
    var title: String? = ""
    var subTitle: String? = ""
    var coordinate : CLLocationCoordinate2D
    
    init(_ title: String, _ subtitle : String , _ coordinate : CLLocationCoordinate2D)
    {
        self.title = title
        self.subTitle = subtitle
        self.coordinate = coordinate
    }
    
    func getLink() -> String
    {
        return subTitle!
    }
}
