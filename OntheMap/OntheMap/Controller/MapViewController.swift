//
//  MapViewController.swift
//  OntheMap
//
//  Created by Ramiz Raja on 02/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    private var mapAnnotations = [MKPointAnnotation]()
    @IBOutlet weak var addNavBarItem: UIBarButtonItem!
    @IBOutlet weak var refreshNavBarItem: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Do any additional setup after loading the view.
        setupAnnotations()
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
                self.clearAllAnnotations()
                self.setupAnnotations()
            } else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Unable to refresh")
            }
        }
    }
    
    private func setupAnnotations() {
        for location in AppData.studentLocations {
            mapAnnotations.append(location.toMKPointAnnotation())
        }
        mapView.addAnnotations(mapAnnotations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func clearAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
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

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reusePin = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePin) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePin)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaUrl = view.annotation?.subtitle! {
                if let validUrl = URL(string: mediaUrl) {
                    openUrl(url: validUrl)
                }
            }
        }
    }
}
