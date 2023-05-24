//
//  Program.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 23.04.2023.
//

import Foundation

struct Program: Codable {
    
    let startTime: Date
    let recentAirTime: AirTime
    let length: Int
    let name: String
    
}

struct AirTime: Codable {
    
    let id: Int
    let channelId: Int
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case channelId = "channelID"
        
    }
    
}
