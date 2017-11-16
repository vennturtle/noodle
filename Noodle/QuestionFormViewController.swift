//
//  QuestionFormViewController.swift
//  Noodle
//
//  Created by MJ Norona on 11/13/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit

class QuestionFormViewController: UIViewController {

    
    
    //outlets
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionScrollView: UIScrollView!
    
    //options
    @IBOutlet weak var option1TextField: UITextField!
    @IBOutlet weak var option2TextField: UITextField!
    @IBOutlet weak var option3TextField: UITextField!
    @IBOutlet weak var option4TextField: UITextField!
    @IBOutlet weak var option5TextField: UITextField!
    @IBOutlet weak var option6TextField: UITextField!
    @IBOutlet weak var option7TextField: UITextField!
    @IBOutlet weak var Option8TextField: UITextField!
    @IBOutlet weak var option9TextField: UITextField!
    @IBOutlet weak var option10TextField: UITextField!
    
    //instance variables
    weak var delegate: CreateSurveyViewController?
    
    var types = ["True or False", "Multiple Choice", "Checkbox"]
    var questionType = ""
    var questions = [String]()
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("hello")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
    
    //picker view is changed
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeTextField.text = self.types[row]
        self.typePickerView.isHidden = true
        self.questionType = self.types[row]
        
        if questionType == "Multiple Choice"
            || questionType == "Checkbox" {
            self.optionLabel.isHidden = false
            self.optionScrollView.isHidden = false
        } else {
            self.optionLabel.isHidden = true
            self.optionScrollView.isHidden = true
        }
    }
    
    
    //text field is changed
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.typeTextField {
            questionType = typeTextField.text!
            self.typePickerView.isHidden = false
        }
    }
    
    
}
