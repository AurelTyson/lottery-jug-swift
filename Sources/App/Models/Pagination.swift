//
//  Pagination.swift
//  App
//
//  Created by Aurélien Tison on 25/11/2017.
//

public final class Pagination: Codable {
    
    // MARK: Attributes
    
    public var object_count: Int
    public var page_number: Int
    public var page_size: Int
    public var page_count: Int
    public var has_more_items: Int
    
    public init() {
        
        self.object_count = 0
        self.page_number = 0
        self.page_size = 0
        self.page_count = 0
        self.has_more_items = 0
        
    }
    
}
