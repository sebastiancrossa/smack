//
//  CreateChannelVC.swift
//  Smack
//
//  Created by Sebastian Crossa on 8/3/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit

class CreateChannelVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var channelDescription: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
    
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(CreateChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
