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
    //member field to be passed from previous controller
    var studentLocation: StudentLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addAnnotation(studentLocation.toMKPointAnnotation())
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish(_ sender: Any) {
        
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
}
