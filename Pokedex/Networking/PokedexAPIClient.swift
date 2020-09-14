//
//  YooxAPIClient.swift
//  Pokedex
//
//  Created by Michele Mola on 03/10/2019.
//  Copyright © 2019 Michele Mola. All rights reserved.
//
import Foundation

class PokedexAPIClient: APIClient {
	var session: URLSession
	
	init(configuration: URLSessionConfiguration) {
		self.session = URLSession(configuration: configuration)
	}
	
	convenience init() {
		self.init(configuration: .default)
	}
	
	typealias PokemonListCompletionHandler = (Result<PokemonReferenceList?, APIError>) -> Void
	
	func getPokemonList(
		withOffset offset: Int,
		andLimit limit: Int,
		completion: @escaping PokemonListCompletionHandler
	) {
		let request = PokedexAPI.getPokemonList(offset: offset, limit: limit).request
		
		fetch(with: request, decode: { json -> PokemonReferenceList? in
			guard let response = json as? PokemonReferenceList else { return nil }
			return response
		}, completion: completion)
	}
	
	typealias PokemonDetailCompletionHandler = (Result<Pokemon?, APIError>) -> Void
	
	func getPokemon(
		byId id: String,
		completion: @escaping PokemonDetailCompletionHandler
	) {
		let request = PokedexAPI.getPokemon(id: id).request
		
		fetch(with: request, decode: { json -> Pokemon? in
			guard let response = json as? Pokemon else { return nil }
			return response
		}, completion: completion)
	}
}

