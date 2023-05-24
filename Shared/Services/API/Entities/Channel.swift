//
//  Channel.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 23.04.2023.
//

struct Channel: Codable {
    
    let id: Int
    let order: Int
    let access: Int
    let callSign: String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case order = "orderNum"
        case access = "accessNum"
        case callSign = "CallSign"
        
    }
    
    init(id: Int, order: Int, access: Int, callSign: String) {
        self.id = id
        self.order = order
        self.access = access
        self.callSign = callSign
    }
    
}
