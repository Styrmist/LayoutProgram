//
//  MockService.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

class MockService<T: Decodable>: APIService<T>, APIServiceFetchable {
    
    typealias ResponseType = T
    
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
        
        super.init(baseURL: "")
    }
    
    func fetch(completion: @escaping (Result<[ResponseType], APIError>) -> Void) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            completion(.failure(APIError.noData))
            
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let items = try decoder.decode([ResponseType].self, from: data)
            
            completion(.success(items))
        } catch {
            completion(.failure(APIError.decodingError))
        }
    }
    
}
