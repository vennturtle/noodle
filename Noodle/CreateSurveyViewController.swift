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
    
    
    
    
    
    
    
    //outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var daysTextfield: UITextField!
    
    @IBOutlet weak var useLocation: UISwitch!
    @IBOutlet weak var locationPicker: MKMapView!
   
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        var newSurvey = Survey(title: titleTextField.text!, desc: descriptionTextView.text, hoursAvailable: 2, latitude: 100, longitude: -200)
        
        
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*var myRef = FIRDatabase.database().reference()
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            let startDate = FIRServerValue.timestamp() as! [String:Any]
            let key = myRef.child("Surveys").childByAutoId().key
            let survey = ["uid": uid,
                          "title": "A Study On Bananas",
                          "desc": "A formal study on the nature of bananas",
                          "startTime:": startDate,
                          "hoursAvailable": 1,
                          "latitude": 37.335,
                          "longitude": -121.819] as [String : Any]
            
            let childUpdates = ["/Surveys/\(key)": survey]
            myRef.updateChildValues(childUpdates)
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

