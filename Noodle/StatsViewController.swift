//

//  StatsViewController.swift

//  Noodle

//

//  Created by Luis E. Arevalo on 11/17/17.

//  Copyright © 2017 pen15club. All rights reserved.

//



import Foundation
import Firebase
import UIKit

//

//  StatsViewController.swift



//  Noodle



//



//  Created by Luis E. Arevalo on 11/16/17.



//  Copyright © 2017 pen15club. All rights reserved.



//


class StatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var myResponse =  ["this is a test" , "this is anotehr test"]
    
    
    
    //tells the table view how many sections to display
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
        
    }
    
    
    
    //displays how manys row to display
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print(questions?[currentIndex].value)
        print("yo \(questions?[currentIndex].options.count)")
        print("pls work \(questions?[currentIndex].options)\n\n\n\n")
        return questions?[currentIndex].options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatsTableViewCell", for: indexPath) as? StatsTableViewCell  else {
            
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            
        }
        
        
        if questions?[currentIndex].type == .TrueOrFalse {
            if indexPath.row == 0{
                cell.responseLabel.text = "TRUE"
                cell.statNumberLabel.text = String(statitics[indexPath.row])

            }
            else if indexPath.row == 1{
                cell.responseLabel.text = "FALSE"
                cell.statNumberLabel.text = String(statitics[indexPath.row])

            }
            else {
                cell.responseLabel.text = "YOU DONE FUCKED UP"
            }
        }
        
        //responseLabel
        
       // cell.responseLabel.text =  questions![currentIndex].options[indexPath.row]
        print("I GOT MORE STA TIT ICS\(statitics)")
       // cell.statNumberLabel.text = String(statitics[indexPath.row])
        
        
        //  let response = myResponse[indexPath.row]
        
        
        return cell
        
        
    }
    
    
    
    //outlets for selectbox and dropdown
    
    
    
    @IBOutlet weak var selectBox: UITextField!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var surveyTitleLabel: UILabel!
    
    // var survey = Survey()
    var survey: Survey?
    var questions: [Question]?
    var answers: [Answer]?
    var statitics: [Int] = []
    var timeleft: Int = 0
    var currentIndex = 0
    
    @IBOutlet weak var statsTableView: UITableView!
    
    //creating the surveys list
    
    
    
    var surveys = ["Survey 1", "Survey 2",  "Survey 3"]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        selectBox.text = "Select a question"
        let myRef =  FIRDatabase.database().reference()
        
        
        self.hideKeyboardWhenTappedAround()
        
        timeleft = (survey?.daysAvailable)!
        
        Question.getAll(bySurveyID: survey!.id!, dbref: myRef) { questions in
            var questionsWithTFOptions = [Question]()
            for q in questions {
                if q.type == .TrueOrFalse {
                    q.options = ["true", "false"]
                }
                questionsWithTFOptions.append(q)
            }
            self.questions = questionsWithTFOptions
            self.statsTableView.reloadData()
            print("Finished downloading \(self.questions!.count) questions.\n\n\n\n")
            
        }
        
        // gets all the answers from the current survey and returns them into answers
        Answer.getAll(bySurveyID: survey!.id!, dbref: myRef) { answers in
            self.answers = answers
            self.statsTableView.reloadData()
            print("Finished downloading \(self.answers!.count) answers. \n\n\n\n\n\n")
        }
        
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
        
        //gets all the answers for the current survey
        
        //        Answer.getAll(bySurveyID: (survey?.id!)!, dbref: myRef ){ (SHITSANDGIGGLES ) in
        //
        //
        //
        //            self.answers = SHITSANDGIGGLES
        //
        //        }
        //
        
        
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
        currentIndex = row
        print("currentIndex = \(currentIndex)\n\n\n")
        if answers != nil && questions != nil {
            self.statitics = Answer.getFrequency(ofQuestion: currentIndex+1, options: questions![currentIndex].options.count, from: answers!) ?? [0]
            print(statitics)
            print("I GOT STA TIT ICS\n\n\n")
        }
        statsTableView.reloadData()
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





