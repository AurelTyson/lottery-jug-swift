//
//  Events.swift
//  App
//
//  Created by Aurélien Tison on 25/11/2017.
//

public final class Events: Codable {
    
    // MARK: Attributes
    
    public var pagination: Pagination
    public var events: [Event]
    
    // MARK: Init
    
    public init() {
        
        self.pagination = Pagination()
        self.events = []
        
    }
    
}
