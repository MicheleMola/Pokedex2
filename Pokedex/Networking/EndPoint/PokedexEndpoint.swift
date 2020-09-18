//
//  YooxEndpoint.swift
//  Pokedex
//
//  Created by Michele Mola on 03/10/2019.
//  Copyright © 2019 Michele Mola. All rights reserved.
//

import Foundation

enum PokedexAPI {
	case getPokemonList(offset: Int, limit: Int)
	case getPokemon(id: String)
}

extension PokedexAPI: Endpoint {
	var base: String {
		return "https://pokeapi.co"
	}
	
	var path: String {
		switch self {
			case .getPokemonList: return "/api/v2/pokemon"
			case .getPokemon(let id): return "/api/v2/pokemon/\(id)"
		}
	}
	
	var queryItems: [URLQueryItem] {
		switch self {
			case .getPokemonList(let offset, let limit):
				return [
					URLQueryItem(name: "offset", value: "\(offset)"),
					URLQueryItem(name: "limit", value: "\(limit)")
				]
			default: return []
		}
	}
}
