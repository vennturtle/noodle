//
//  CreateSurveyViewController.swift
//  Noodle
//
//  Created by Brandon Cecilio on 10/24/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CreateSurveyViewController: UIViewController {
    @IBOutlet weak var useLocation: UISwitch!
    @IBOutlet weak var locationPicker: MKMapView!
    
    @IBAction func enableLocation(_ sender: Any) {
        locationPicker.isHidden = !useLocation.isOn
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

