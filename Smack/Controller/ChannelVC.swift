//
//  ChannelVC.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/29/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changing the value of the amount revealed
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
