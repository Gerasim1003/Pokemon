//
//  PokemonsResponseModel.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import Foundation

// MARK: - PokemonsResponseModel
struct PokemonsResponseModel: Codable {
    let count: Int
    let next: String?
    let results: [Pokemon]
}

// MARK: - Result
struct Pokemon: Codable {
    let name: String
    let url: String
}
