//
//  UIUtils.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/5/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import UIKit

class UIUtils {
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    func showAlertView(message: String, parent: UIViewController) {
        let alert = UIAlertController.init(title: "Udacity OnTheMap", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        parent.present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator(show: Bool, parent: UIView) {
        activityIndicatorView.alpha = 1
        activityIndicatorView.center = CGPoint(x: parent.frame.width/2, y: parent.frame.height/2)
        if show {
            activityIndicatorView.startAnimating()
            parent.addSubview(activityIndicatorView)
        } else {
            activityIndicatorView.stopAnimating()
            parent.willRemoveSubview(activityIndicatorView)
        }
    }
    
    class func shared() -> UIUtils {
        struct Singleton {
            static var sharedInstance = UIUtils()
        }
        return Singleton.sharedInstance
    }
    
}
