//
//  StudentAddMapViewController.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/24/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import UIKit
import MapKit

class StudentAddMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationText: String?
    var webText: String?
    var studentLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard studentLocation != nil else {
            return
        }
        let annotation = MKPointAnnotation.init()
        annotation.coordinate = studentLocation!
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegionMakeWithDistance(studentLocation!, 100, 100)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIUtils.shared().showActivityIndicator(show: true, parent: view)
    }

    @IBAction func onFinish(_ sender: Any) {
        guard let current = ParseClient.shared().loggedInStudent else {
            return
        }
        current.webURL = webText ?? ""
        current.mapString = locationText ?? ""
        current.coordinate = studentLocation!
        
        if !current.postedPreviously {
            ParseClient.shared().postStudent(current) { (result, error) in
                guard error == nil else {
                    UIUtils.shared().showAlertView(message: error!, parent: self)
                    return
                }
                guard let result = result else {
                    UIUtils.shared().showAlertView(message: "No results while posting", parent: self)
                    return
                }
                do {
                    let resultDict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String: AnyObject]
                    current.objectId = resultDict["objectId"] as! String
                    current.postedPreviously = true
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    UIUtils.shared().showAlertView(message: "Error while parsing post result", parent: self)
                }
            }
        } else {
            ParseClient.shared().putStudent(current) { (data, error) in
                guard error == nil else {
                    UIUtils.shared().showAlertView(message: error!, parent: self)
                    return
                }
                guard let data = data else {
                    UIUtils.shared().showAlertView(message: "No results while updating", parent: self)
                    return
                }
                do {
                    let resultDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                    print(resultDict)
                } catch { }
            }
        }
    }
}

extension StudentAddMapViewController : MKMapViewDelegate {
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        UIUtils.shared().showActivityIndicator(show: false, parent: self.view)
    }
}
