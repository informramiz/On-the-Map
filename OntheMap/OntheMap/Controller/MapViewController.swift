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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupAnnotations()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController : MKMapViewDelegate {
    
}
