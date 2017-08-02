//
//  AuthService.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/30/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// Handle user registration
class AuthService {
    
    static let instance = AuthService()
    
    // Easiest way of saving persistent data on the device
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        // Get = When we try to access it
        // Set = When we try to set it
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        } set  {
            defaults.set(newValue, forKey: LOGGED_IN_KEY) // newValue = Whatever value we write down when setting it
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        } set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        } set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    // Function in charge of registering a user with a web request
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        // Creating the actual web request
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    // Function in charge of logging in the user, with an AUTH token as a response
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        // Request that will recieve the auth token of the email logged in
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            // JSON parsing
            if response.result.error == nil {
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                
                // Using SwiftyJSON
                guard let data = response.data else { return } // Making sure data exists
                let json = JSON(data: data) // Creating a data object
                
                self.userEmail = json["user"].stringValue // Safely unwraps it as a String for us with .stringValue
                self.authToken = json["token"].stringValue
                
                // Succesfully logged in a user
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    // Function in charge of creating the user
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                // JSON parsing
                guard let data = response.data else { return }
                
                // Will set the users data
                self.setUserInfo(data: data)
                
                completion(true)
            } else {
                completion(false)
                debugPrint("-- Smack : Error in createUser function", response.result.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                // JSON parsing
                guard let data = response.data else { return }
                
                // Will set the users data
                self.setUserInfo(data: data)
                
                completion(true)
            } else {
                completion(false)
                debugPrint("-- Smack : Error in createUser function", response.result.error as Any)
            }
        }
    }
    
    
    func setUserInfo(data: Data) {
        let json = JSON(data: data)
        
        // Variables that will be passed to the UserDataService function created
        let id = json["_id"].stringValue
        let color = json["avatarColor"].stringValue
        let avatarName = json["avatarName"].stringValue
        let email = json["email"].stringValue
        let name = json["name"].stringValue
        
        UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
    }
    
}
