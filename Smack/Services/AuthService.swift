//
//  AuthService.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/30/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import Foundation
import Alamofire

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
                if let json = response.result.value as? Dictionary<String, Any> {
                    if let email = json["user"] as? String {
                        self.userEmail = email
                    }
                    
                    if let token = json["token"] as? String {
                        self.authToken = token
                    }
                }
                
                // Succesfully logged in a user
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
}
