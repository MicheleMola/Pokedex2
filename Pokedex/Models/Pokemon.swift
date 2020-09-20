//
//  Pokemon.swift
//  Pokedex
//
//  Created by Michele Mola on 25/03/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

struct PokemonReference: Decodable {
	let name: String
	let url: URL
	
	var id: String {
		self.url.lastPathComponent
	}
}

struct PokemonReferenceList: Decodable {
	let count: Int
	let results: [PokemonReference]
}

struct Pokemon: Decodable, Equatable {
	let name: String
	let id: Int
	let types: [TypeResponse]
	let sprites: Sprites
	let stats: [StatResponse]
	
	var imageURL: URL? {
		URL(string: "https://pokeres.bastionbot.org/images/pokemon/\(self.id).png")
	}
	
	var primaryType: PokemonType? {
		guard let type = self.types.first?.type.name else { return nil }
		return PokemonType(rawValue: type)
	}
	
	static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
		lhs.name == rhs.name && lhs.id == rhs.id
	}
}

struct TypeResponse: Decodable {
	let type: NameResponse
}

struct Sprites: Decodable {
	let frontDefault: URL
	
	private enum CodingKeys: String, CodingKey {
		case frontDefault = "front_default"
	}
}

struct StatResponse: Decodable {
	let baseStat: Int
	let statistic: NameResponse
	
	private enum CodingKeys: String, CodingKey {
		case baseStat = "base_stat"
		case statistic = "stat"
	}
}

struct NameResponse: Decodable {
	let name: String
}
