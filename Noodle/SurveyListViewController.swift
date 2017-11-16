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

    var myRef = FIRDatabase.database().reference()

    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "surveyList", for: indexPath) as!
        SurveyListTableViewCell
        
        
        cell.titleLabel.text = "testing "
        cell.ownerLabel.text = "ffff"
        cell.descriptionLabel.text = "THIS IS A TEST LETS SEE IF IT WORKS "
        
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("\n\nCurrent Surveys:")
        self.myRef.child("Surveys").observe(.value, with: { snapshot in
            for child in snapshot.children {
                let values = child as? FIRDataSnapshot
                let model = Survey(values!)!
                print(model.id!)
                print(model.title)
                print(model.startDate!)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
