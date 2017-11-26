//
//  Attendees.swift
//  App
//
//  Created by Aurélien Tison on 25/11/2017.
//

public final class Attendees: Codable {
    
    // MARK: Attributes
    
    public var pagination: Pagination
    public var attendees: [Attendee]
    
    // MARK: Init
    
    public init() {
        
        self.pagination = Pagination()
        self.attendees = []
        
    }
    
}
