//
//  BaseViewController.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/23/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController {
    func doLogout() {
        UIUtils.shared().showActivityIndicator(show: true, parent: view)
        UdacityClient.shared().logout() { (data, error) in
            guard error == nil else {
                UIUtils.shared().showActivityIndicator(show: false, parent: self.view)
                UIUtils.shared().showAlertView(message: error ?? "", parent: self)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func doAdd() {
        if let current = ParseClient.shared().loggedInStudent, current.postedPreviously {
            let message = "Details for student \(current.firstName) \(current.lastName) already exists"
            let alertController = UIAlertController.init(title: "On The Map", message: message, preferredStyle: .alert)
            let dismiss = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
            let overwrite = UIAlertAction.init(title: "Overwrite", style: .default) { (action) in
                self.showAddController()
            }
            alertController.addAction(dismiss)
            alertController.addAction(overwrite)
            present(alertController, animated: true, completion: nil)
        } else {
            showAddController()
        }
        
    }
    
    func showAddController() {
        let addController = storyboard?.instantiateViewController(withIdentifier: "AddLocation")
        present(addController!, animated: true, completion: nil)
    }
}
