//
//  MySurveysViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/14/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import UIKit
class MySurveysViewController: UIViewController {
    
    
    
    @IBOutlet weak var recievedDataLabel: UILabel!
    
    var receivedData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //variible that holds data being passed from the first controller 
        recievedDataLabel.text = receivedData
        print(receivedData)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
