//
//  EventBriteController.swift
//  App
//
//  Created by Aurélien Tison on 24/11/2017.
//

import Vapor
import HTTP

public final class EventBriteController {
    
    // MARK: Attributes
    
    private let drop: Droplet
    private let token: String
    private let organizerId: String
    
    private var eventId: String?
    private var lastEvent: Event?
    private var attendees: [Attendee]
    
    // MARK: Init
    
    public init(drop: Droplet) throws {
        
        // Init
        self.drop = drop
        self.token = self.drop.config["app", "TOKEN"]?.string ?? ""
        self.organizerId = self.drop.config["app", "ORGANIZER_ID"]?.string ?? ""
        self.attendees = []
        
        // Loading last event and all attendees
        if let lLastEventId = try self.getLastEvent()?.id {
            try self.loadAllAttendees(eventId: lLastEventId)
        }
        
    }
    
    // MARK: Methods
    
    private func getRandomIds(max: Int, numbers: Int) -> [Int] {
        
        if numbers >= max {
            return Array.init(0...max)
        }
        
        var lToRet = [Int]()
        
        while lToRet.count < numbers {
            
            let lRandom = self.randomInt(min: 0, max: max)
            
            !lToRet.contains(lRandom) ? lToRet.append(lRandom) : nil
            
        }
        
        return lToRet
        
    }
    
    private func getLastEvent() throws -> Event? {
        
        let lResponse = try self.drop.client.get("https://www.eventbriteapi.com/v3/events/search/",
                                                 query: ["sort_by" : "date",
                                                         "organizer.id" : self.organizerId,
                                                         "token" : self.token])
        
        do {
            
            let lEvents: Events = try lResponse.decodeJSONBody()
            return lEvents.events.first
            
        }
        catch {
            return nil
        }
        
    }
    
    public func loadAllAttendees(eventId: String) throws {
        
        let lResponse = try self.drop.client.get("https://www.eventbriteapi.com/v3/events/\(eventId)/attendees/",
                                                 query: ["page" : 1,
                                                         "token" : self.token])
        
        let lAttendees: Attendees = try lResponse.decodeJSONBody()
        
        self.attendees.append(contentsOf: lAttendees.attendees)
        
        let lPageNumber = lAttendees.pagination.page_number + 1
        let lPageCount = lAttendees.pagination.page_count
        
        if lPageNumber < lPageCount {
            
            for i in lPageNumber...lPageCount {
                
                let lNextAttendeesResponse = try self.drop.client.get("https://www.eventbriteapi.com/v3/events/\(eventId)/attendees/",
                    query: ["page" : i,
                            "token" : self.token])
                
                let lNextAttendees: Attendees = try lNextAttendeesResponse.decodeJSONBody()
                
                self.attendees.append(contentsOf: lNextAttendees.attendees)
                
            }
            
        }
        
    }
    
    // MARK: Utils
    
    private func randomInt(min: Int, max: Int) -> Int {
        #if os(Linux)
            return Int(random() % max) + min
        #else
            return Int(arc4random_uniform(UInt32(max)) + UInt32(min))
        #endif
    }
    
    // MARK: Requests
    
    public func winners(_ req: Request) throws -> ResponseRepresentable {
        
        guard let nbWinners = req.data["nb"]?.int, nbWinners > 0 else {
            return try [Int]().makeResponse()
        }
        
        return try self.getRandomIds(max: self.attendees.count - 1, numbers: nbWinners)
            .map({ self.attendees[$0].profile })
            .makeResponse()
        
    }
    
}
