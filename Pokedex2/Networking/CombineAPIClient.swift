//
//  CombineAPIClient.swift
//  Pokedex2
//
//  Created by Michele Mola on 28/04/2020.
//

import Combine
import Foundation

struct CombineAPIClient {
	/// A shared JSON decoder to use in calls.
	private let decoder = JSONDecoder()
		
	func getPokemons(withOffset offset: Int, andLimit limit: Int) -> AnyPublisher<[PokemonReference], APIError> {
		let request = PokedexAPI.getPokemonList(offset: offset, limit: limit).request

		return URLSession.shared
			.dataTaskPublisher(for: request)
			.map(\.data)
			.decode(type: PokemonReferenceList.self, decoder: decoder)
			.mapError { error -> APIError in
				switch error {
				case is URLError:
					return APIError.requestFailed
				default:
					return APIError.responseUnsuccessful
				}
			}
			.map(\.results)
			.eraseToAnyPublisher()
	}
	
	func getPokemon(byId id: String) -> AnyPublisher<Pokemon, APIError> {
		let request = PokedexAPI.getPokemon(id: id).request
		
		return URLSession.shared
			.dataTaskPublisher(for: request)
			.map(\.data)
			.decode(type: Pokemon.self, decoder: decoder)
			.mapError { error -> APIError in
				switch error {
				case is URLError:
					return APIError.requestFailed
				default:
					return APIError.responseUnsuccessful
				}
			}
			.eraseToAnyPublisher()
	}
}
