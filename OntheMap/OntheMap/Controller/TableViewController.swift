//
//  TableViewController.swift
//  OntheMap
//
//  Created by Ramiz Raja on 02/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNavBarItem: UIBarButtonItem!
    @IBOutlet weak var refreshNavBarItem: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        OnTheMapClient.logout { (success, error) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onRefresh(_ sender: Any) {
        onDataRefresh(inProgress: true)
        OnTheMapClient.getStudentLocations { (success, error) in
            self.onDataRefresh(inProgress: false)
            if success {
                self.tableView.reloadData()
            } else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Unable to refresh")
            }
        }
    }
    
    private func onDataRefresh(inProgress: Bool) {
        refreshNavBarItem.isEnabled = !inProgress
        addNavBarItem.isEnabled = !inProgress
        if inProgress {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}

extension TableViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell")!
        cell.textLabel?.text = AppData.studentLocations[indexPath.row].fullName
        cell.detailTextLabel?.text = AppData.studentLocations[indexPath.row].mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: AppData.studentLocations[indexPath.row].mediaURL) {
            openUrl(url: url)
        } else {
            showErrorAlert(message: "No valid URL found")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
