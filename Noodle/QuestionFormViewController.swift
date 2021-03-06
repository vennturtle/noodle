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
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var promptTextField: UITextView!
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
    @IBOutlet weak var option8TextField: UITextField!
    @IBOutlet weak var option9TextField: UITextField!
    @IBOutlet weak var option10TextField: UITextField!
    
    //instance variables
    weak var delegate: CreateSurveyViewController?
    
    var types = ["True or False", "Multiple Choice", "Checkbox"]
    var questionType = ""
    var questions = [Question]()
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("hello")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        saveQuestion()
        questionLabel.text = "Q" + String(questions.count+1) + ":"
        print("saved")
    }
    
    func saveQuestion(){
        let type = typeTextField.text
        let prompt = promptTextField.text
        var options = [String]()
        var questionType: Int?
        
        if type == "True or False" {
            print("True or False")
            questionType = 0
            
        } else {
            if type == "Multiple Choice"{
                questionType = 1
            } else {
                questionType = 2
            }
            if self.option1TextField.text != "" {
                options.append(self.option1TextField.text!)
            }
            if self.option2TextField.text != "" {
                options.append(self.option2TextField.text!)
            }
            if self.option3TextField.text != "" {
                options.append(self.option3TextField.text!)
            }
            if self.option4TextField.text != "" {
                options.append(self.option4TextField.text!)
            }
            if self.option5TextField.text != "" {
                options.append(self.option5TextField.text!)
            }
            if self.option6TextField.text != "" {
                options.append(self.option6TextField.text!)
            }
            if self.option7TextField.text != "" {
                options.append(self.option7TextField.text!)
            }
            if self.option8TextField.text != "" {
                options.append(self.option8TextField.text!)
            }
            if self.option9TextField.text != "" {
                options.append(self.option9TextField.text!)
            }
            if self.option10TextField.text != "" {
                options.append(self.option10TextField.text!)
            }
        }
        
        let newQuestion = Question(prompt: prompt!, type: questionType!, options: options)!
        questions.append(newQuestion)
        
        promptTextField.text = ""
        typeTextField.text = "True or False"
        optionLabel.isHidden = true
        optionScrollView.isHidden = true
        option1TextField.text = ""
        option2TextField.text = ""
        option3TextField.text = ""
        option4TextField.text = ""
        option5TextField.text = ""
        option6TextField.text = ""
        option7TextField.text = ""
        option8TextField.text = ""
        option9TextField.text = ""
        option10TextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeTextField.text = "True or False"
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
            textField.endEditing(true)
            self.typePickerView.isHidden = false
        }
    }
    
    
}
