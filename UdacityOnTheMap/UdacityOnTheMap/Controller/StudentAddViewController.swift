//
//  StudentAddViewController.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/24/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import UIKit
import CoreLocation

class StudentAddViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var webTextField: UITextField!
    
    var locationText: String?
    var webText: String?
    var studentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        webTextField.delegate = self
    }
    
    @IBAction func onFindLocation(_ sender: UIButton) {
        guard let url = webTextField.text, isValidUrl(url) else {
            UIUtils.shared().showAlertView(message: "Please enter valid Website url.", parent: self)
            return
        }
        guard let location = locationTextField.text, location.characters.count > 0 else {
            UIUtils.shared().showAlertView(message: "Please enter valid location text.", parent: self)
            return
        }
        UIUtils.shared().showActivityIndicator(show: true, parent: self.view)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placemark, error) in
            guard error == nil else {
                UIUtils.shared().showActivityIndicator(show: false, parent: self.view)
                UIUtils.shared().showAlertView(message: "Error while getting location information: Invalid location", parent: self)
                return
            }
            if let place = placemark, place.count > 0 {
                let placeLocation: CLLocation = (place.first?.location)!
                self.studentLocation = placeLocation.coordinate
                self.locationText = location
                self.webText = url
                UIUtils.shared().showActivityIndicator(show: false, parent: self.view)
                self.performSegue(withIdentifier: "StudentCoordinate", sender: self)
            }
        }
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! StudentAddMapViewController
        destinationController.locationText = locationText
        destinationController.webText = webText
        destinationController.studentLocation = studentLocation
    }
    
    // MARK: - private
    func isValidUrl(_ urlString: String) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return predicate.evaluate(with: urlString)
    }
}

extension StudentAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
