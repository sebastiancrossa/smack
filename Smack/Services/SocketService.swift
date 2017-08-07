//
//  SocketService.swift
//  Smack
//
//  Created by Sebastian Crossa on 8/3/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    // Creating our frst instance of the socket
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    // Creating the connections between the app and the web client
    func establishConnection() {
        socket.connect() // Connects to the servcer
    }
    
    func closeConnection() {
        socket.disconnect() // Disconnects from the server
    }
    
    // In charge of creating the the channels
    // emit = send data, on = receive datas
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription) // newChannel comes from the server API source
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let name = dataArray[0] as? String else { return } // We know the position of it because of the API source code
            guard let description = dataArray[1] as? String else { return }
            guard let id = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: name, channelDescription: description, id: id)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        } // channelCreated comes from the server API source
    }
    
    // In charge of registerng and sending the messages typed  by the users
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatrarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatrarColor, id: id, timeStamp: timeStamp)
            
            completion(newMessage)
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            
            completionHandler(typingUsers)
        }
    }
}
