//
//  ChatVC.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/29/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var messageTextBox: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingUserLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Automatic sizing each cell depending on the text sent
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sendButton.isHidden = true
        
        // Manually adding the reveal toggle to the menuButton
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        // Implement gesture recognizers that will help make the reveal smoother
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // Notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                
                self.tableView.reloadData()
                
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
                }
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = "" // Will hold the names of who is typing
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                
                if numberOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingUserLabel.text = "\(names) \(verb) typing a message..."
            } else {
                self.typingUserLabel.text = ""
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            // Get the channels
            onLoginGetMessages()
        } else {
            channelNameLabel.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
        if messageTextBox.text == "" {
            isTyping = false
            sendButton.isHidden = true
            
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        } else {
            if isTyping == true {
                sendButton.isHidden = false
                
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            
            sendButton.isHidden = false
            isTyping = true
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTextBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTextBox.text = ""
                    
                    self.messageTextBox.resignFirstResponder()
                    
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                }
            })
        }
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No channels yet!!"
                }
            } 
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    // Conforming to the table view protocols
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
