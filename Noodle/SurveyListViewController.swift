//
//  SurveyListViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/13/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SurveyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var databaseHandler: FIRDatabaseHandle?
    var myRef = FIRDatabase.database().reference()
    var surveyInformationArray = [String]()
    
    
    
    var titleLabel: String?
    var descriptionLabel: String?
    var owner: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n\nCurrent Surveys:")
        myRef.child("Surveys").observe(.value, with: { snapshot in
            for child in snapshot.children {
                let values = child as? FIRDataSnapshot
                let dict = values?.value as? NSDictionary
                
                print(values!.key)
                print(dict!["title"] as! NSString)
            }
        })
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "surveyList", for: indexPath) as!
        SurveyListTableViewCell
            
            
//            if let child = FIRDataSnapshot.children as? [String: AnyObject]{
//                
//                
//                print(child)
//                let title = child["title"] as? String
//                
//                print(self.title)
//            }
//            
//        })
        
        
        //            myRef.observe(.value, with: { snapshot in
        //          for child in snapshot.children.allObjects{
        //
        //                }
        //            })
        //
        //
        //
        //                print(snapshot.children)
        //
        //
        //                //print(child)
        //                let childDict = child as? NSDictionary
        //
        //                print(childDict)
        //                let title = childDict?["title"] as? String ?? "penis"
        //
        //                print(" YET\n\n\n")
        //                print(title)
        //
        //                print(" YEEEEEETI")
        //
        //            }
        //
        
        
        //     });
        
        //  let userID = FIRAuth.auth()?.currentUser?.uid
        
        
        
        //        var myArray = [String]()
        //        myArray.append("this is testing survey")
        //        myArray.append("this is a testitle title")
        //
        //myRef.child("Users").child(userID!).child("Survey 1").child("Surveys").setValue(myArray)
        
        //        myRef.child("Users").child(userID!).child("Surveys").observeSingleEvent(of: .value, with: {( FIRDataSnapshot) in
        //
        //            if let dictionary = FIRDataSnapshot.value as? [String:AnyObject]{
        //                cell.titleLabel.text = dictionary["Title"] as? String
        //                cell.descriptionLabel.text = dictionary["Description"] as? String
        //
        //
        //
        //            }
        //
        //        })
        //
        cell.ownerLabel.text = "ffff"
        
        
        //            let detail = FIRDataSnapshot.value as? String
        //            if let actualDetail = detail{
        //                self.surveyInformationArray.append(actualDetail)
        //      )
        
        
        
        // print(surveyInformationArray)
        
        // cell.titleLabel.text = "testing "
        //  cell.descriptionLabel.text = "THIS IS A TEST LETS SEE IF IT WORKS "
        
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
