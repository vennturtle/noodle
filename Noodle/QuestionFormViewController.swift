//
//  QuestionFormViewController.swift
//  Noodle
//
//  Created by MJ Norona on 11/13/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit

class QuestionFormViewController: UIViewController {

    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var typePickerView: UIPickerView!
    
    var types = ["True or False", "Multiple Choice", "Checkbox"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension QuestionFormViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeTextField.text = self.types[row]
        self.typePickerView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.typeTextField {
            self.typePickerView.isHidden = false
        }
    }
}
