//
//  StatsViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/17/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import Foundation
import UIKit

//

//  StatsViewController.swift

//  Noodle

//

//  Created by Luis E. Arevalo on 11/16/17.

//  Copyright © 2017 pen15club. All rights reserved.

//



import Foundation
import UIKit



class StatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //outlets for selectbox and dropdown
    
    @IBOutlet weak var selectBox: UITextField!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    var survey = Survey()
    //creating the surveys list
    
    var surveys = ["Survey 1", "Survey 2",  "Survey 3"]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectBox.text = "Select a question"
        
        self.hideKeyboardWhenTappedAround()
        
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
        
        
        
        return surveys.count
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        
        let title = surveys[row]
        return title
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        self.selectBox.text = self.surveys[row]
        
        self.dropDown.isHidden = true
        
        
        
    }
    
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.selectBox {
            
            
            
            self.dropDown.isHidden = false

            textField.endEditing(true)
            
        }
        
        
    }
    
}




