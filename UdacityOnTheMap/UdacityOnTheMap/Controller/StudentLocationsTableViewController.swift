//
//  SecondViewController.swift
//  UdacityOnTheMap
//
//  Created by Jean Ro on 10/8/17.
//  Copyright © 2017 Jean Ro. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        doLogout()
    }
    
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
        doRefresh()
    }
    
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        doAdd()
    }
    
    func doRefresh() {
        UIUtils.shared().showActivityIndicator(show: true, parent: view)
        ParseClient.shared().getStudentLocations() { (error) in
            guard error == nil else {
                UIUtils.shared().showAlertView(message: "Error while refreshing data", parent: self)
                return
            }
            self.tableView.reloadData()
            UIUtils.shared().showActivityIndicator(show: false, parent: self.view)
        }
    }
}

extension StudentLocationsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let students = ParseClient.shared().students else {
            return 0
        }
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell = tableView.dequeueReusableCell(withIdentifier: "studentLocationsTableCell")
        if tableCell == nil {
            tableCell = UITableViewCell(style: .subtitle, reuseIdentifier: "studentLocationsTableCell")
        }
        guard let students = ParseClient.shared().students else {
            return tableCell!
        }
        let student = students[indexPath.row]
        let first = student["firstName"] as? String
        let last = student["lastName"] as? String
        let url = student["mediaURL"] as? String
        
        if let first=first, let last=last, let url=url {
            tableCell?.textLabel?.text = "\(first) \(last)"
            tableCell?.detailTextLabel?.text = url
            tableCell?.imageView?.image = UIImage(named: "icon_pin")
        }
        return tableCell!
    }
}

extension StudentLocationsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let students = ParseClient.shared().students else {
            return
        }
        let mediaUrl = students[indexPath.row]["mediaURL"] as? String
        guard mediaUrl != nil else {
            return
        }
        guard let url = URL(string: mediaUrl!) else {
            return
        }
        UIApplication.shared.open(url, options:[:] , completionHandler: nil)
    }
}

