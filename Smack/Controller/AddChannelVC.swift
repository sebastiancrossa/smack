//
//  AddChannelVC.swift
//  Smack
//
//  Created by Sebastian Crossa on 8/3/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var channelDescription: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = nameText.text , nameText.text != "" else { return }
        guard let description = channelDescription.text else { return }
        
        let transformedName = name.replacingOccurrences(of: " ", with: "-")
        
        SocketService.instance.addChannel(channelName: transformedName, channelDescription: description) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
