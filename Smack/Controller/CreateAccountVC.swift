//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/29/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        guard let email = emailText.text , emailText.text != "" else { return }
        guard let pass = passwordText.text, passwordText.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success  {
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        print("-- Smack : Logged in user with token of ", AuthService.instance.authToken)
                    }
                })
            }
        }
    }
    
    // Will unwind over to the targetted view, which was set to the ChannelVC
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
