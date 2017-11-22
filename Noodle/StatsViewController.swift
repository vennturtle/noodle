//
//  StatsViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/16/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import Firebase
import UIKit

// drop down menu selects question and graph will display on the left the number of responses for each question and the bottom will display the answers which will be shown as a bar chart.
//call survey methods to populate the title, description and time left
// using the survey that was passed into this class.
class StatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //outlets for selectbox and dropdown
    @IBOutlet weak var selectBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var questionPrompt: UILabel!
    @IBOutlet weak var statsTableView: UITableView!
    
    // var survey = Survey()
    var survey: Survey?
    var questions: [Question]?
    var answers: [Answer]?
    var statistics: [Int]?
    var currentIndex = -1 {
        didSet {
            self.updateStatistics(questionIndex: currentIndex)
            self.questionPrompt.isHidden = false
            self.questionPrompt.text = questions?[currentIndex].prompt ?? "downloading questions..."
            self.statsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectBox.text = "Select a question"
        let myRef =  FIRDatabase.database().reference()
        self.hideKeyboardWhenTappedAround()
        
        Question.getAll(bySurveyID: survey!.id!, dbref: myRef) { questions in
            self.questions = questions
            DispatchQueue.main.async {
                print("Finished downloading \(self.questions!.count) questions. Updating table...\n")
                self.statsTableView.reloadData()
            }
        }
        
        // gets all the answers from the current survey and returns them into answers
        Answer.getAll(bySurveyID: survey!.id!, dbref: myRef) { answers in
            self.answers = answers
            DispatchQueue.main.async {
                print("Finished downloading \(self.answers!.count) answers. Updating table...\n")
                self.statsTableView.reloadData()
            }
        }
        
        surveyTitleLabel.text = survey?.title ?? "No Title"
        descriptionLabel.text = survey?.desc ?? "No Description"
        timeLeftLabel.text = survey?.timeRemainingString() ?? "None"
        
        descriptionLabel.sizeToFit()
        descriptionLabel.numberOfLines = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateStatistics(questionIndex qindex: Int){
        guard let qs = self.questions else {
            print("Cannot update statistics: currently missing questions.")
            return
        }
        guard let ans = self.answers else {
            print("Cannot update statistics: currently missing answers.")
            return
        }
        let numOps = qs[qindex].options.count
        if let stats = Answer.getFrequency(ofQuestion: qindex, options: numOps, from: ans) {
            self.statistics = stats
        } else { print("Error found when updating statistics") }
    }
    
    /* table view delegate functions */
    
    //tells the table view how many sections to display
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    //displays how manys row to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print(questions?[currentIndex].value)
        if questions != nil && answers != nil && currentIndex >= 0 {
            if let question = questions?[currentIndex] {
                if question.type == .TrueOrFalse {
                    return 2
                }
                return question.options.count
            }
            else { return 0 }
        }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatsTableViewCell", for: indexPath) as? StatsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of StatsTableViewCell.")
        }
        
        // special labels if the question type is true or false
        let row = indexPath.row
        if questions?[currentIndex].type == .TrueOrFalse {
            switch(row){
            case 0:  cell.responseLabel.text = "True"
            case 1:  cell.responseLabel.text = "False"
            default: cell.responseLabel.text = "YOU DONE FUCKED UP"
            }
        }
        else {
            cell.responseLabel.text = questions?[currentIndex].options[indexPath.row]
        }
        cell.statNumberLabel.text = String(statistics![indexPath.row])
        return cell
    }
    
    /* picker view delegate functions */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    { return survey?.qids.count ?? 0 }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    { return "Question \(row + 1)" }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectBox.text = "Question \(row + 1)"
        self.dropDown.isHidden = true
        currentIndex = row
        print("Set currentIndex = \(currentIndex)\n")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.selectBox {
            self.dropDown.isHidden = false
            textField.endEditing(true)
        }
    }
}
