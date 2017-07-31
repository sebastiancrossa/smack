//
//  UserDataService.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/31/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import Foundation

class UserDataService {
    
    // Singleton
    static let instance = UserDataService()
    
    // public getter and private setter
    // Other classes are able to see it but only this class is able to modify it
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
}
