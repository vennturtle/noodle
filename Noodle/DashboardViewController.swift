//
//  DashboardViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/8/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation



class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myRef = FIRDatabase.database().reference()
    var currentSurveys: [Survey] = []
    var surveyUpdateHandle: FIRDatabaseHandle?
    var surveyUpdateQuery: FIRDatabaseQuery?
    
    //tableView outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath) as! HomeTableViewCell
        
        cell.selectionStyle = .none
//        if indexPath.row % 2 == 0 { // 189, 231, 126
//            cell.backgroundColor = UIColor(red: 80/255.0, green: 206/255.0, blue: 80/255.0, alpha: 1.0)
//        } else {
//            cell.backgroundColor = UIColor(red: 111/255.0, green: 214/255.0, blue: 111/255.0, alpha: 1.0)
//        }
        cell.titleLabel.text = currentSurveys[indexPath.row].title
        cell.timeLabel.text = String(currentSurveys[indexPath.row].timeRemainingString()!)
        cell.descriptionLabel.text = currentSurveys[indexPath.row].desc
        return cell
    }
    
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSurveys.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid =  FIRAuth.auth()?.currentUser?.uid {
            // model tests
            print("Running model tests:")
            Question.get(byID: "-Kz3WpLll869kXPj30eI", dbref: self.myRef) { question in
                print(question?.prompt ?? "question not found")
            }
            Survey.get(byID: "-Kz6D0juXAl9igsEEpFo", dbref: self.myRef) { survey in
                print(survey?.title ?? "survey not found")
            }
            Survey.getAll(byUserID: uid, dbref: self.myRef) { surveys in
                for s in surveys {
                    print(s.title)
                }
            }
            let currentLocation = CLLocation(latitude: 37.3352, longitude: -121.8811)
            let radius = 40.0
            Survey.getAll(near: currentLocation, radiusInKm: radius, dbref: self.myRef) { surveys in
                print("These are all within \(radius) km of campus:")
                for s in surveys {
                    print("\(s.id!): \(s.title) (\(s.latitude), \(s.longitude))")
                }
            }
            print("Model tests initiated. Awaiting response from server...")
            
            // populate currentSurveys with logged in user's surveys
            let queryAndHandle = Survey.keepGettingAll(byUserID: uid, dbref: myRef){ surveys in
                self.currentSurveys = surveys
                self.tableView.reloadData()
            }
            self.surveyUpdateQuery = queryAndHandle.0
            self.surveyUpdateHandle = queryAndHandle.1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutAction(_ sender: UIButton) {
        if FIRAuth.auth()?.currentUser != nil{
            do {
                if surveyUpdateHandle != nil {
                    surveyUpdateQuery?.removeObserver(withHandle: surveyUpdateHandle!)
                }
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn")
                present(vc, animated: true, completion: nil )
            }
            catch let error as NSError{
                print(error.localizedDescription)
                
            }
        }
    }
    
    //segues into stats view controller when a cell is selected
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        print("\n\n\n\n\n")
        
        
        //gets the cell the user clicks on
        print("row: \(indexPath.row)")
        
        let cellSelected = indexPath.row
        let sur =  currentSurveys[cellSelected]
        
        print("\n\n\n\n\n")
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "Stats") as! StatsViewController
        controller.survey = sur
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    @IBAction func unwindFromSurveyList(segue: UIStoryboardSegue){}
    
    
}
