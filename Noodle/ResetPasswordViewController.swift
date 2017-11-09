//
//  ResetPasswordViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/8/17.
//  Copyright © 2017 pen15club. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth


class ResetPasswordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    @IBAction func resetPasswordAction(_ sender: UIButton) {
        if emailTextField.text == ""{
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            
        }else {
            
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextField.text!, completion: {( error) in
                
                var title = ""
                var message = ""
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                }
                else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController,animated: true, completion: nil)
            })
            
        }
        
        
        
    }
}
    
