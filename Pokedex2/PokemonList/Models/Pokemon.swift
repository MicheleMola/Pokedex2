//
//  Pokemon.swift
//  Pokedex
//
//  Created by Michele Mola on 25/03/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

struct PokemonReference: Codable {
	let name: String
	let url: URL
	
	var id: String {
		self.url.lastPathComponent
	}
}

struct PokemonReferenceList: Codable {
	let count: Int
	let results: [PokemonReference]
}

struct Pokemon: Codable {
	let name: String
	let id: Int
	let types: [TypeResponse]
	let sprites: Sprites
	let stats: [StatResponse]
	let weight: Int
	let height: Int
	
	var imageURL: URL? {
		URL(string: "https://pokeres.bastionbot.org/images/pokemon/\(id).png")
	}
	
	var primaryType: PokemonType? {
		if types.count > 1, let secondTypeName = types.last?.type.name {
			return PokemonType(rawValue: secondTypeName)
		} else if let firstTypeName = types.first?.type.name {
			return PokemonType(rawValue: firstTypeName)
		}
		
		return nil
	}
}

struct TypeResponse: Codable {
	let type: NameResponse
}

struct Sprites: Codable {
	let frontDefault: URL
	
	private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct StatResponse: Codable {
	let baseStat: Int
	let stat: NameResponse
	
	private enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat", stat
    }
}

struct NameResponse: Codable {
	let name: String
}
