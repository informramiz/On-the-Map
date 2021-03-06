//
//  ShowLocationOnMapViewController.swift
//  OntheMap
//
//  Created by Ramiz Raja on 12/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit
import MapKit

class ShowLocationOnMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //member field to be passed from previous controller
    var studentLocation: StudentLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setCenter(studentLocation.toCoordinate2D(), animated: false)
        mapView.addAnnotation(studentLocation.toMKPointAnnotation())
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish(_ sender: Any) {
        isLocationSaving(inProgress: true)
        OnTheMapClient.postStudentLocation(studentLocation: studentLocation) { (success, error) in
            self.isLocationSaving(inProgress: false)
            if success {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Unable to save location")
            }
        }
    }
    
    func isLocationSaving(inProgress: Bool) {
        finishButton.isEnabled = !inProgress
        if inProgress {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension ShowLocationOnMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "PinView"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = true
            pinView!.tintColor = .red
            pinView!.isDraggable = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let url = URL(string: view.annotation!.subtitle!!) {
            openUrl(url: url)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        self.studentLocation = self.studentLocation.copy(location: view.annotation!.coordinate)
    }
}
