//
//  Attendee.swift
//  App
//
//  Created by Aurélien Tison on 25/11/2017.
//

public final class Attendee: Codable {
    
    // MARK: Attributes
    
    public var profile: Profile
    
    // MARK: Init
    
    public init() {
        
        self.profile = Profile()
        
    }
    
}

public final class Profile: Codable {
    
    // MARK: Attributes
    
    public var name: String
    public var email: String
    public var first_name: String
    public var last_name: String
    
    // MARK: Init
    
    public init() {
        
        self.name = ""
        self.email = ""
        self.first_name = ""
        self.last_name = ""
        
    }
    
}
