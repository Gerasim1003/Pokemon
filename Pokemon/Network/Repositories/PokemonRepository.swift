//
//  PokemonRepository.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import Foundation

struct PokemonRepository {
    // MARK: - Properties
    
    private let networkService: NetworkService
    
    // MARK: - Init
    
    init() {
        let config = ApiDataNetworkConfig(baseURL: URL(string: NetworkEnvironment.BaseUrl.stormGlass)!)
        
        networkService = NetworkService(config: config)
    }
}

// MARK: - Public methods
extension PokemonRepository {
    func getPokemons(offset: Int, limit: Int, _ completion: @escaping (_ data: PokemonsResponseModel?, _ error: NetworkError?) -> Void) {
        networkService.request(endpoint: Endpoints.pokemons(offset, limit), completion)
    }
    
    func getPokemonDetails(by url: String, _ completion: @escaping (_ data: PokemonDetailsResponseModel?, _ error: NetworkError?) -> Void) {
        networkService.request(endpoint: Endpoints.pokemonDetails(url), completion)
    }
}


// MARK: - Endpoints
extension PokemonRepository {
    struct Endpoints {
        static func pokemons(_ offset: Int, _ limit: Int) -> Endpoint {
            let params = ["offset": offset, "limit": limit]
            return Endpoint(path: "/api/v2/pokemon", method: .get, queryParameters: params)
        }
        
        static func pokemonDetails(_ url: String) -> Endpoint {
            return Endpoint(path: url, isFullPath: true, method: .get)
        }
    }
}
