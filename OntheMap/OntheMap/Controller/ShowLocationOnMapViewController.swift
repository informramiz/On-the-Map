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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish(_ sender: Any) {
        
    }
}
