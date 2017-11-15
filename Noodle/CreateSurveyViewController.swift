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
   
    
    var myRef: FIRDatabaseReference?
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        var newSurvey = Survey(title: titleTextField.text!, desc: descriptionTextView.text, daysAvailable: Int(daysTextfield.text!)!, latitude: -200, longitude: 200)
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRef = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

