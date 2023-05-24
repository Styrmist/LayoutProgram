//
//  ChannelsService.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

class ChannelsService: APIService<Channel>, APIServiceFetchable {
    
    init() {
        super.init(baseURL: "https://192.168.50.52/json")
    }
    
    func fetch(completion: @escaping (Result<[Channel], APIError>) -> Void) {
        fetch(
            withEndpoint: "Channels",
            method: .get,
            completion: completion
        )
    }
    
    func fetch(withOffset offset: Int, completion: @escaping (Result<[Channel], APIError>) -> Void) {
        fetch(
            withEndpoint: "Channels",
            method: .get,
            completion: completion
        )
    }
    
}
