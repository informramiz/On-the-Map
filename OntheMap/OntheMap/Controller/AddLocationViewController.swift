//
//  AddLocationViewController.swift
//  OntheMap
//
//  Created by Ramiz Raja on 08/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let hideKeyboardDelegate = HideKeyboardOnEnterDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressTextField.delegate = hideKeyboardDelegate
        urlTextField.delegate = hideKeyboardDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard isAllDataValid() else { return }
        geocode(address: addressTextField.text!) { (location) in
            self.gotoNextScreen(location: location)
        }
    }
    
    private func isAllDataValid() -> Bool {
        if (addressTextField.text!.isEmpty) {
            showErrorAlert(message: "Please enter a valid address")
            return false
        } else if (!urlTextField.text!.isValidUrl()) {
            showErrorAlert(message: "Please enter a valid url")
            return false
        }
        
        return true
    }
    
    private func geocode(address: String, onSuccess: @escaping (CLLocationCoordinate2D) -> Void) {
        isActivityInProgress(inProgress: true)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.isActivityInProgress(inProgress: false)
            guard let placemarks = placemarks, placemarks.count > 0, placemarks.first?.location != nil else {
                self.showErrorAlert(message: "Unable to find location for the address")
                return
            }
            
            onSuccess(placemarks.first!.location!.coordinate)
        }
    }
    
    private func gotoNextScreen(location: CLLocationCoordinate2D) {
        let studentLocation = StudentLocation(address: addressTextField.text!,
                                              url: urlTextField.text!,
                                              userId: AppData.userId,
                                              location: location)
        self.performSegue(withIdentifier: "ShowLocationOnMap", sender: studentLocation)
    }
    
    private func isActivityInProgress(inProgress: Bool) {
        findLocationButton.isEnabled = !inProgress
        if inProgress {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let studentLocation = sender as! StudentLocation
        let showLocationOnMapController = segue.destination as! ShowLocationOnMapViewController
        showLocationOnMapController.studentLocation = studentLocation
    }
}
