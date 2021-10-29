//
//  PokemonsViewModel.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import Foundation

class PokemonsViewModel {
    // MARK: - Properties
    
    private(set) var pokemons = [Pokemon]()
    
    private var repository = PokemonRepository()
    
    private var limit = 10
    private var offset = 0
    private var pokemonsLeft = true
    
}

// MARK: - Public methods

extension PokemonsViewModel {
    func getPokemons(_ completion: @escaping (_ error: NetworkError?) -> Void) {
        guard pokemonsLeft else { return }
        repository.getPokemons(offset: offset, limit: limit) { [weak self] data, error in
            guard let self = self else { return }
            if self.offset == 0 {
                self.pokemons = data?.results ?? []
            } else {
                self.pokemons += data?.results ?? []
            }
            self.offset += self.limit
            self.pokemonsLeft = data?.next != nil
            completion(error)
        }
    }
    
    func reset() {
        offset = 0
    }
}
