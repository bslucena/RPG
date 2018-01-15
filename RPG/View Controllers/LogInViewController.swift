//
//  LogInViewController.swift
//  RPG
//
//  Created by Bernardo Sarto de Lucena on 12/26/17.
//  Copyright © 2017 Bernardo Sarto de Lucena. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBAction func signInButtonSelected(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (user, error) in
                
                if user != nil {
                    self.dismiss(animated: true, completion: nil)
//                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "SignInToMainPage", sender: nil)
//                    print("user authenticated")

                } else {
                    self.popAlert(title: "Something Went Wrong", message: (error?.localizedDescription)!)
                    return
                }
            }
        } else {
            popAlert(title: "Alert", message: "Please fill all the fields.")
        }
    }
    
    
    @IBAction func signUpButtonSelected(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
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
