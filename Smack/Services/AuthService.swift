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
    
    var isLogged: Bool {
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
    
    // Function that is in charge of handling the web request
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        // Defining the header and body
        let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        // Creating the actual web request
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
}
