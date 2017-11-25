//
//  LoginViewController.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 11/4/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Student information cache
    //static var firstName: String = ""
    //static var lastName: String = ""
    //static var userId: String = ""
    
    let udacitySignupURL = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginButton.isEnabled = false
        guard let email = emailTextField.text,
            email.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
                UIUtils.shared().showAlertView(message: "Please enter email.", parent: self)
                return
        }
        guard let password = passwordTextField.text,
            password.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
                UIUtils.shared().showAlertView(message: "Please enter password.", parent: self)
                return
        }
        
        UIUtils.shared().showActivityIndicator(show: true, parent: self.view)
        UdacityClient.shared().login(email: email, password: password) { (result, error) in
            guard error == nil else {
                self.showErrorMessage(error ?? "Error returned from Udacity login")
                return
            }
            guard let result = result else {
                self.showErrorMessage("Nil result returned from Udacity login")
                return
            }
            let range = Range(5 ..< result.count)
            let correctedData = result.subdata(in: range)
            var loginDict: Dictionary<String, AnyObject>
            do {
                loginDict = try JSONSerialization.jsonObject(with: correctedData, options: .allowFragments) as! [String : AnyObject]
            } catch {
                self.showErrorMessage("Json serialization failed during login")
                return
            }
            let accountDict = loginDict["account"] as? [String : AnyObject?]
            guard let accountInfo = accountDict else {
                self.showErrorMessage("Account dictionary missing in login json")
                return
            }
            let userID = accountInfo["key"] as? String
            guard userID != nil else {
                self.showErrorMessage("User ID missing in login json")
                return
            }
            
            UdacityClient.shared().getStudent(userID!) { (data, error) in
                guard error == nil else {
                    self.showErrorMessage(error ?? "Error returned from Student details call")
                    return
                }
                guard let data = data else {
                    self.showErrorMessage("Nil result returned from student details call")
                    return
                }
                var dataDict: Dictionary<String, AnyObject>
                var userDict: Dictionary<String, AnyObject>
                do {
                    dataDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    userDict = dataDict["user"] as! [String : AnyObject]
                    let loggedIn = ["firstName": userDict["first_name"] as! String,
                                    "lastName": userDict["last_name"] as! String,
                                    "userId": userID!] as [String: AnyObject]
                    
                    ParseClient.shared().loggedInStudent = Student(loggedIn)
                } catch {
                    self.showErrorMessage("Json serialization failed for student details call")
                    return
                }
                //Student data fetch is done - go to next screen
                DispatchQueue.main.async {
                    print("Student: \(ParseClient.shared().loggedInStudent?.firstName) \(ParseClient.shared().loggedInStudent?.lastName), \(ParseClient.shared().loggedInStudent?.userId) ")
                    UIUtils.shared().showActivityIndicator(show: false, parent: self.view)
                    self.performSegue(withIdentifier: "loginFinished", sender: self)
                }
            }
        }

        
    }
    @IBAction func signupButtonPressed(_ sender: Any) {
        let url = URL(string: udacitySignupURL)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            UIUtils.shared().showActivityIndicator(show: false, parent: self.view)
            UIUtils.shared().showAlertView(message: message, parent: self)
            self.loginButton.isEnabled = true
        }
    }
}
