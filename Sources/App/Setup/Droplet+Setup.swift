@_exported import Vapor

extension Droplet {
    
    public func setup() throws {
        try setupRoutes()
        
        // EventBrite controller
        let eventBriteController = try EventBriteController(drop: self)
        self.get("winners", handler: eventBriteController.winners)
        
    }
    
}
