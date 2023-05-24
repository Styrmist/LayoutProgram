//
//  APIError.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

enum APIError: Error {
    
    case networkError(Error)
    case httpError(HTTPError)
    case encodingURLError
    case decodingError
    case noData
    case canceled
    
}
