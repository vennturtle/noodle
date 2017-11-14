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
import Firebase


class CreateSurveyViewController: UIViewController {
    @IBOutlet weak var useLocation: UISwitch!
    @IBOutlet weak var locationPicker: MKMapView!
    var myRef: FIRDatabaseReference!
    
    
    @IBAction func enableLocation(_ sender: Any) {
        locationPicker.isHidden = !useLocation.isOn
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myRef = FIRDatabase.database().reference()
        
       // print("\n\n\n\n\n\nYEET\n\n\n\n\n\n")
        createSurvey()
       // print("\n\n\n\n\n\nYEET\n\n\n\n\n\n")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createSurvey(){
        
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            let startDate = FIRServerValue.timestamp() as! [String: Any]
            let key = myRef.child("Surveys").childByAutoId().key
            let survey = ["uid": uid,
                          "title": "My title",
                          "decription": "my description",
                          "startTime": startDate,
                          "numDays": 1 as NSNumber,
                          "latitude": 37.3352 as NSNumber,
                          "longitude": -121.811 as NSNumber] as [String : Any]
            
            let childUpdates = ["/Surveys/\(key)": survey]
            myRef.updateChildValues(childUpdates)
            
            
        }
  
        }
        
        
    
    
}

