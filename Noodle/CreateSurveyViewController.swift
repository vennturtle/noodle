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

class CreateSurveyViewController: UIViewController, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        locationPicker.setRegion(region, animated:true)
        self.locationPicker.showsUserLocation = true
    }
    


    
    //outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var daysTextfield: UITextField!
    
    @IBOutlet weak var useLocation: UISwitch!
    @IBOutlet weak var locationPicker: MKMapView!
   
    
    var myRef: FIRDatabaseReference?
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        var latitude = manager.location?.coordinate.latitude
        var longitude = manager.location?.coordinate.longitude
        
        print("longitude: \(longitude)")
        print("latitude: \(latitude)")
        var newSurvey = Survey(title: titleTextField.text!, desc: descriptionTextView.text, daysAvailable: Int(daysTextfield.text!)!, latitude: latitude!, longitude: longitude!)
        let uid = FIRAuth.auth()?.currentUser?.uid
        newSurvey.submitNewSurvey(dbref: myRef!, authorID: uid!)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QuestionSegue" {
            let navigationController = segue.destination as! UINavigationController
            let questionViewController = navigationController.topViewController as! QuestionFormViewController
            questionViewController.delegate = self
        }
    }
    
    //unwinded from cancel button
    @IBAction func unwindQuestions(segue: UIStoryboardSegue){
        let questionViewController = segue.source as! QuestionFormViewController
        print(questionViewController.questionType)
    }

    
    @IBAction func enableLocation(_ sender: Any) {
        locationPicker.isHidden = !useLocation.isOn
        manager.requestWhenInUseAuthorization()

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied){
            showLocationisablePopUp()
        }
    }
    
    func showLocationisablePopUp(){
        let alertController = UIAlertController(title: "Location Access Disabled", message: "In order for us to match you with surveys, we will need access to your location", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default){(action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        myRef = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

