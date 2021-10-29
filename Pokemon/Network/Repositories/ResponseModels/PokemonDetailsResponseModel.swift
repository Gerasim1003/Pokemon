//
//  PokemonDetailsResponseModel.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import Foundation

// MARK: - PokemonDetailsResponseModel

struct PokemonDetailsResponseModel: Codable {
    let name: String
    let weight: Int
    let height: Int
    let types: [PokemonTypeModel]
    private let sprites: PokemonSprites
    
    var imageUrl: String { sprites.other?.artwork?.imageUrl ?? sprites.imageUrl }
    
    var formattedWeight: String { "\(Float(weight) / 1000) kg" }
    
    var formattedHeight: String { "\(height) cm" }
}

// MARK: - PokemonSprites

struct PokemonSprites: Codable {
    enum CodingKeys: String, CodingKey {
        case other
        case imageUrl = "front_default"
    }
    
    let other: PokemonSpritesOther?
    let imageUrl: String
}

struct PokemonSpritesOther: Codable {
    enum CodingKeys: String, CodingKey {
        case artwork = "official-artwork"
    }
    
    let artwork: PokemonArtwork?
}

struct PokemonArtwork: Codable {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "front_default"
    }
    
    let imageUrl: String?
}

// MARK: -

struct PokemonTypeModel: Codable {
    private let type: PokemonType
    
    var name: String { type.name }
}

struct PokemonType: Codable {
    let name: String
}
