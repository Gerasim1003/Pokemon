//
//  PokemonDetailsViewModel.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import Foundation

class PokemonDetailsViewModel {
    // MARK: - Properties
    private var repository = PokemonRepository()
    
    private let pokemon: Pokemon
    
    private(set) var details: PokemonDetailsResponseModel?
    
    // MARK: - Init
    
    init(_ pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}

// MARK: - Public methods
extension PokemonDetailsViewModel {
    func getDetails(_ completion: @escaping (_ error: NetworkError?) -> Void) {
        repository.getPokemonDetails(by: pokemon.url) { [weak self] data, error in
            self?.details = data
            completion(error)
        }
    }
}
