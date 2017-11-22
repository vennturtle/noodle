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
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         myRef = FIRDatabase.database().reference()
        self.title = currentSurvey!.title
        
        
        Question.get(byID: currentSurvey!.qids[0], dbref:  myRef!){
            question in
            DispatchQueue.main.async {
                print("getting question")
                self.currentQuestion = question!
                self.currentOptions = (question?.options)!
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
        let header = "Q1: \(currentQuestion.prompt)"
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
    }
}
