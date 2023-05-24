//
//  ProgramsService.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

class ProgramsService: APIService<Program>, APIServiceFetchable {
    
    init() {
        super.init(baseURL: "https://192.168.50.52/json")
    }
    
    func fetch(completion: @escaping (Result<[Program], APIError>) -> Void) {
        fetch(
            withEndpoint: "ProgramItems",
            method: .get,
            completion: completion
        )
    }
    
    func fetch(withOffset offset: Int, completion: @escaping (Result<[Program], APIError>) -> Void) {
        fetch(
            withEndpoint: "ProgramItems",
            method: .get,
            completion: completion
        )
    }
    
}
