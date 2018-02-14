@_exported import Vapor

extension Droplet {
    
    public func setup(forceNoEvent: Bool) throws {
        try setupRoutes()
        
        // EventBrite controller
        let eventBriteController = try EventBriteController(drop: self, forceNoEvent: forceNoEvent)
        self.get("winners", handler: eventBriteController.winners)
        
    }
    
}
