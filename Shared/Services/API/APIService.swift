//
//  APIService.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

protocol APIServiceFetchable<ResponseType>: AnyObject {
    
    associatedtype ResponseType: Decodable
    
    func fetch(completion: @escaping (Result<[ResponseType], APIError>) -> Void)
    
}

private protocol APIServiceProtocol: AnyObject {
    
    associatedtype ResponseType: Decodable
    
    var baseURL: String { get }
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
    
    func fetch(withEndpoint endpoint: String, method: HTTPMethod, withParameters parameters: [String: String?]?, completion: @escaping (Result<[ResponseType], APIError>) -> Void)
    
}

class APIService<T: Decodable>: APIServiceProtocol {
    typealias ResponseType = T
    
    let baseURL: String
    let session = URLSession.shared
    let decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetch(withEndpoint endpoint: String, method: HTTPMethod, withParameters parameters: [String: String?]? = nil, completion: @escaping (Result<[ResponseType], APIError>) -> Void) {
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/json/\(endpoint)"
        
        if let parameters = parameters {
            urlComponents?.queryItems = parameters.compactMap {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.encodingURLError))
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(.httpError(HTTPError.statusCode(statusCode))))
                return
            }
            
            do {
                guard let items = try self?.decoder.decode([ResponseType].self, from: data) else {
                    completion(.failure(.canceled))
                    return
                }
                
                completion(.success(items))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
}
