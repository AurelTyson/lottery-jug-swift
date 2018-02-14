//
//  EventBriteController.swift
//  App
//
//  Created by Aurélien Tison on 24/11/2017.
//

import HTTP
import Vapor

public final class EventBriteController {
    
    // MARK: Attributes
    
    private let drop: Droplet
    private let token: String
    private let organizerId: String
    private let forceNoEvent: Bool
    
    // MARK: Init
    
    public init(drop: Droplet, forceNoEvent: Bool) throws {
        
        // Init
        self.drop = drop
        self.token = self.drop.config["app", "TOKEN"]?.string ?? ""
        self.organizerId = self.drop.config["app", "ORGANIZER_ID"]?.string ?? ""
        self.forceNoEvent = forceNoEvent
        
    }
    
    // MARK: Methods
    
    private func getRandomIds(max: Int, numbers: Int) -> [Int] {
        
        if numbers >= max {
            return Array.init(0...max)
        }
        
        var lToRet = [Int]()
        
        while lToRet.count < numbers {
            
            let lRandom = Int.random(min: 0, max: max)
            
            !lToRet.contains(lRandom) ? lToRet.append(lRandom) : nil
            
        }
        
        return lToRet
        
    }
    
    private func getLastEvent() throws -> Event? {
        
        // If need to force no event
        guard self.forceNoEvent == false else {
            return nil
        }
        
        // Get events
        let lResponse = try self.drop.client.get("https://www.eventbriteapi.com/v3/events/search/",
                                                 query: ["sort_by" : "date",
                                                         "organizer.id" : self.organizerId,
                                                         "token" : self.token])
        
        do {
            
            // Extract data
            let lEvents: Events = try lResponse.decodeJSONBody()
            
            // Returning first event
            return lEvents.events.first
            
        }
        catch {
            
            // No event found
            return nil
            
        }
        
    }
    
    public func loadAllAttendees(eventId: String) throws -> [Attendee] {
        
        // Get attendees
        let lResponse = try self.drop.client.get("https://www.eventbriteapi.com/v3/events/\(eventId)/attendees/",
                                                 query: ["page" : 1,
                                                         "token" : self.token])
        
        // Extract data
        let lAttendees: Attendees = try lResponse.decodeJSONBody()
        
        // Attendees to return
        var lAttendeesToRet = lAttendees.attendees
        
        // Check page
        let lPageNumber = lAttendees.pagination.page_number + 1
        let lPageCount = lAttendees.pagination.page_count
        
        if lPageNumber < lPageCount {
            
            for i in lPageNumber...lPageCount {
                
                // Loading next attendees
                let lNextAttendeesResponse = try self.drop.client.get("https://www.eventbriteapi.com/v3/events/\(eventId)/attendees/",
                    query: ["page" : i,
                            "token" : self.token])
                
                // Extract data
                let lNextAttendees: Attendees = try lNextAttendeesResponse.decodeJSONBody()
                
                // Add new attendees
                lAttendeesToRet.append(contentsOf: lNextAttendees.attendees)
                
            }
            
        }
        
        // Return all attendees
        return lAttendeesToRet
        
    }
    
    // MARK: Requests
    
    public func winners(_ req: Request) throws -> ResponseRepresentable {
        
        // Extract params
        guard let nbWinners = req.data["nb"]?.int, nbWinners >= 0 else {
            return Response(status: .badRequest)
        }
        
        // Loading event
        guard let lLastEvent = try self.getLastEvent() else {
            return Response(status: .badGateway)
        }
        
        // Loading all attendees
        let lAttendees = try self.loadAllAttendees(eventId: lLastEvent.id)
        
        // Empty array if no attendees
        guard lAttendees.count > 0 else {
            return try [Int]().makeResponse()
        }
        
        // Get winners
        return try self.getRandomIds(max: lAttendees.count - 1, numbers: nbWinners)
            .map({ lAttendees[$0].profile })
            .makeResponse()
        
    }
    
}
