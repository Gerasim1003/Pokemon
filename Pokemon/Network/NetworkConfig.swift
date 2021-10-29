//
//  NetworkConfig.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import Foundation

public struct ApiDataNetworkConfig {
    public let baseURL: URL
    public let headers: [String: String]
    
     public init(baseURL: URL,
                 headers: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
    }
}
