//
//  StatsViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/17/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import UIKit

//

//  StatsViewController.swift

//  Noodle

//

//  Created by Luis E. Arevalo on 11/16/17.

//  Copyright © 2017 pen15club. All rights reserved.

//



import Foundation
import UIKit
import Firebase



class StatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //outlets for selectbox and dropdown
    
    @IBOutlet weak var selectBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    
    // var survey = Survey()
    var survey: Survey?
    var answers: [Answer]?
    var statitics: [Int]?
    var timeleft: Int = 0
    
    
    //creating the surveys list
    
    var surveys = ["Survey 1", "Survey 2",  "Survey 3"]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectBox.text = "Select a question"
        
        self.hideKeyboardWhenTappedAround()
        timeleft = (survey?.daysAvailable)!
        
        
        print("printing the label")
        print(survey?.title)
        print("\n\n\n\n")
        
        
        surveyTitleLabel.text = (survey!.title)
        descriptionLabel.text = survey?.desc
        timeLeftLabel.text = String(timeleft)
        
        // tells how many questions
        // will be used to the set the bottom of the bar chart
        
        survey?.questions.count
        
        //returns a reference to the database
        let myRef =  FIRDatabase.database().reference()
        
        
        //gets all the answers for the current survey
        Answer.getAll(bySurveyID: (survey?.id!)!, dbref: myRef ){ (SHITSANDGIGGLES ) in
            
            self.answers = SHITSANDGIGGLES
        }
        
        //returns integer array
        //takes in the question number from the drop down and converts it into an array of ints
        // corresponds to the choice number
        //statitics = Answer.getFrequency(ofQuestion: 1, from: self.answers!)
        
        
        //gets the statitics of choice one from the choosen question
        //  statitics?[0]
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        // guard surveys.count != 0 else { return 0 }
        
        
        
        return survey?.qids.count ?? 0
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        
        //        let title = surveys[row]
        //        return title
        
        return "Question \(row + 1)"
        
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        self.selectBox.text = "Question \(row + 1)"
        
        self.dropDown.isHidden = true
        
        //        self.selectBox.text = self.surveys[row]
        //
        //        self.dropDown.isHidden = true
        
        
        
    }
    
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.selectBox {
            
            
            
            self.dropDown.isHidden = false
            
            textField.endEditing(true)
            
        }
        
        
    }
    
}



// drop down menu selects question and graph will display on the left the number of responses for each question and the bottom will display the answers which will be shown as a bar chart.
//call survey methods to populate the title, description and time left
// using the survey that was passed into this class.



