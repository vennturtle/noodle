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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
