//
//  NetworkService.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int?, data: Data?, message: String?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

// MARK: - NetworkService -

class NetworkService {
    // MARK: - Properties
    
    private let config: ApiDataNetworkConfig
    private let logger = NetworkLogger()
    
    // MARK: - Init
    
    init(config: ApiDataNetworkConfig) {
        self.config = config
    }
    
    // MARK: - Public methods
    
    public func request<T: Codable>(endpoint: Requestable, _ completion: @escaping (_ data: T?, _ error: NetworkError?) -> Void) {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            request(urlRequest, completion)
        } catch {
            completion(nil, NetworkError.generic(error))
        }
    }
    
    // MARK: - Private methods
    
    private func request<T: Codable>(_ request: URLRequest, _ completion: @escaping (_ data: T?, _ error: NetworkError?) -> Void) {
        self.logger.log(request: request)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, requestError in
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data, message: response.description)
                } else {
                    error = self.resolve(error: requestError)
                }
                self.logger.log(error: error)
                completion(nil, error)
            } else {
                self.logger.log(responseData: data, response: response)
                guard let data = data else {
                    completion(nil, NetworkError.cancelled)
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(decodedData, nil)
                } catch let error {
                    self.logger.log(error: error)
                    completion(nil, NetworkError.generic(error))
                }
            }
        }
        dataTask.resume()
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case URLError.Code(rawValue: -1020): return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}
