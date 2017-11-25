//
//  FirstViewController.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 10/8/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import MapKit

class StudentLocationsMapViewController: BaseViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIUtils.shared().showActivityIndicator(show: true, parent: view)
    }
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        doLogout()
    }
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
        fetchStudentData()
    }
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        doAdd()
    }
}

extension StudentLocationsMapViewController: MKMapViewDelegate {
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        fetchStudentData()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        UIUtils.shared().showActivityIndicator(show: false, parent: view)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "studentPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        guard pinView != nil else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        }
        pinView?.annotation = annotation
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func fetchStudentData() {
        UIUtils.shared().showActivityIndicator(show: true, parent: view)
        disableButtons()
        ParseClient.shared().getStudentLocations() { (error) in
            guard error == nil else {
                self.showErrorAndEnableButtons(error!)
                return
            }
            self.addAnnotations()
            UIUtils.shared().showActivityIndicator(show: false, parent: self.view)
            self.enableButtons()
        }
    }
    
    private func addAnnotations() {
        guard let students = ParseClient.shared().students else {
            return
        }
        var annotations = [MKPointAnnotation]()
        for student in students {
            let lat = student["latitude"] as? CLLocationDegrees
            let long = student["longitude"] as? CLLocationDegrees
            let first = student["firstName"] as? String
            let last = student["lastName"] as? String
            let url = student["mediaURL"] as? String
            
            if let lat=lat, let long=long, let first=first, let last=last, let url=url {
                let annotation = MKPointAnnotation()
                annotation.title = "\(first) \(last)"
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotation.coordinate = coord
                annotation.subtitle = url
                annotations.append(annotation)
            }
        }
        
        mapView.addAnnotations(annotations)
    }
    
    func showErrorAndEnableButtons(_ errorMessage:String) {
        UIUtils.shared().showAlertView(message: errorMessage, parent: self)
        refreshButton.isEnabled = true
        addButton.isEnabled = true
        logoutButton.isEnabled = true
    }
    func disableButtons() {
        refreshButton.isEnabled = false
        addButton.isEnabled = false
        logoutButton.isEnabled = false
        mapView.isOpaque = true
    }
    func enableButtons() {
        self.refreshButton.isEnabled = true
        self.addButton.isEnabled = true
        self.logoutButton.isEnabled = true
        self.mapView.isOpaque = false
    }
}

