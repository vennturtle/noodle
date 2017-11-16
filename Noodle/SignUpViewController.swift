//
//  SignUpViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/8/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    var myRef = FIRDatabase.database().reference()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createAccount(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" || nameField.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid Name, email or password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
        else if confirmPasswordTextField.text != passwordTextField.text{
            
            let alertController = UIAlertController(title: "Error", message: "Please make sure passwords match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if passwordTextField.text!.characters.count < 6 || confirmPasswordTextField.text!.characters.count < 6 {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter a password longer than 6 characters.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            print("\nAuthenticating connection to database...")
            let auth = FIRAuth.auth()
            print("Authentication " + (auth == nil ? "un" : "") + "successful.")
            auth?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
                print("Creating user...")
                if error == nil {
                    print("User created.")
                    print("You have signed in.")
                    
                    let newUser = ["Name" : self.nameField.text!, "Email": self.emailTextField.text!]
                    self.myRef.child("Users").child((user?.uid)!).setValue(newUser)
                    
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                }
                else {
                    print("User was not created: " + error!.localizedDescription)
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
