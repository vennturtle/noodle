//
//  TestViewController.swift
//  Noodle
//
//  Created by Salvador Rodriguez on 11/17/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit
import Firebase
//THIS will be answers
class TakeSurveyViewController: UIViewController {
    var currentSurvey: Survey?
    var myRef: FIRDatabaseReference?
    var questions = [Question]()
    var currentQuestion = Question()
    var currentOptions = [String]()
    var surveyIndex = 0
    var currentAnswers = Set<Int>()
    var allAnswers = Answer()
    
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var topLeftCornerButton: UIBarButtonItem!
    @IBOutlet weak var topRightCornerButton: UIBarButtonItem!
    
    @IBAction func topLeftButtonPressed(_ sender: UIBarButtonItem) {
        
        if topLeftCornerButton.title! == "Cancel" {
            dismiss(animated: true, completion: nil)
        } else {
            surveyIndex -= 1
            print("current question: \(surveyIndex)")
            print("amount of questions: \((currentSurvey?.qids.count)!)")
            //
            _ = allAnswers.choices.popLast()
            
            
            //remove checkmarks
            let cells = self.tableViewOutlet.visibleCells
            for cell in cells {
                cell.accessoryType = .none
            }
            
            //top LEFT corner button config
            if surveyIndex == 0 {
                topLeftCornerButton.title = "Cancel"
            } else {
                topLeftCornerButton.title = "Back"
            }
            
            //top RIGHT corner button config
            if surveyIndex == ((currentSurvey?.qids.count)! - 1) {
                print("going here for last question")
                topRightCornerButton.title = "Done"
            } else {
                topRightCornerButton.title = "Next"
            }
            
            Question.get(byID: currentSurvey!.qids[surveyIndex], dbref:  myRef!){
                question in
                DispatchQueue.main.async {
                    
                    print("getting question")
                    self.currentQuestion = question!
                    if question!.type == .TrueOrFalse {
                        self.currentOptions = ["True", "False"]
                    } else {
                        self.currentOptions = (question?.options)!
                    }
                    
                    //gray out sections
                    if question!.type == .MultipleSelection {
                        self.tableViewOutlet.allowsMultipleSelection = true;
                    } else {
                        self.tableViewOutlet.allowsMultipleSelection = false;
                    }
                    
                    print(question?.prompt ?? "question is not loaded")
                    self.tableViewOutlet.reloadData()
                }
                
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRef = FIRDatabase.database().reference()
        self.title = currentSurvey!.title
        if currentSurvey!.qids.count == 1 {
            self.topRightCornerButton.title = "Done"
        }
        
        Question.get(byID: currentSurvey!.qids[surveyIndex], dbref:  myRef!){
            question in
            DispatchQueue.main.async {
                print("getting question")
                self.currentQuestion = question!
                if question!.type == .TrueOrFalse {
                    self.currentOptions = ["True", "False"]
                } else {
                    self.currentOptions = (question?.options)!
                }
                
                //gray out sections
                if question!.type == .MultipleSelection {
                    self.tableViewOutlet.allowsMultipleSelection = true;
                } else {
                    self.tableViewOutlet.allowsMultipleSelection = false;
                }
                print(question?.prompt ?? "question is not loaded")
                self.tableViewOutlet.reloadData()
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        surveyIndex += 1
        print("current question: \(surveyIndex)")
        print("amount of questions: \((currentSurvey?.qids.count)!)")
        //added to choices of answers
        allAnswers.choices.append(currentAnswers)
        
        if topRightCornerButton.title == "Done"{
            allAnswers.submit(dbref: myRef!, userID: userID!, surveyID: currentSurvey!.id!)
            print("submitting")
            dismiss(animated: true, completion: nil)
        } else {
            //remove checkmarks
            let cells = self.tableViewOutlet.visibleCells
            for cell in cells {
                cell.accessoryType = .none
            }
            
            //top LEFT corner button config
            if surveyIndex == 0 {
                topLeftCornerButton.title = "Cancel"
            } else {
                topLeftCornerButton.title = "Back"
            }
            
            //top RIGHT corner button config
            if surveyIndex == ((currentSurvey?.qids.count)! - 1) {
                print("going here for last question")
                topRightCornerButton.title = "Done"
            }
            if let count = currentSurvey?.qids.count {
                if surveyIndex < count {
                    Question.get(byID: currentSurvey!.qids[surveyIndex], dbref:  myRef!){
                        question in
                        DispatchQueue.main.async {
                            
                            print("getting question")
                            self.currentQuestion = question!
                            if question!.type == .TrueOrFalse {
                                self.currentOptions = ["True", "False"]
                            } else {
                                self.currentOptions = (question?.options)!
                            }
                            
                            //gray out sections
                            if question!.type == .MultipleSelection {
                                self.tableViewOutlet.allowsMultipleSelection = true;
                            } else {
                                self.tableViewOutlet.allowsMultipleSelection = false;
                            }
                            
                            print(question?.prompt ?? "question is not loaded")
                            self.tableViewOutlet.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TakeSurveyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        cell.textLabel?.text = currentOptions[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOptions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = "Q\(surveyIndex + 1): \(currentQuestion.prompt)"
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if currentQuestion.type == .MultipleSelection {
            currentAnswers.insert(indexPath.row)
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            currentAnswers = Set<Int>([indexPath.row])
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if currentQuestion.type == .MultipleSelection {
            currentAnswers.remove(indexPath.row)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}
