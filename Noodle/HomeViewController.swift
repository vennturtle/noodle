//
//  HomeViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/13/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import UIKit



class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath) as! HomeTableViewCell
        
        cell.surveyLabel.text = "this is a test"
        
        return cell
        
    }

    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
