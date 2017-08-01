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
    
    func returnUIColor(components: String) -> UIColor {
        // Example of returned color
        // "[0.588235294117647, 0.807843137254902, 0.309803921568627, 1]
        
        // Lets us scan the passed string
        let scanner = Scanner(string: components)
        
        let skipped = CharacterSet(charactersIn: "[], ") // Specify what characters we want to be skipped
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        // Scan up to the first comma, skipping the braces and spaces, saving the first value found into the variable r
        // The scanner will continue where it left off
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        // Default color if it fails
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }
        
        // Cast each of the values into CGFloats
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        
        return newUIColor
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
