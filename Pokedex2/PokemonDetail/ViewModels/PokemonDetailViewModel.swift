//
//  PokemonDetailViewModel.swift
//  Pokedex2
//
//  Created by Michele Mola on 25/04/2020.
//

import Foundation

class PokemonDetailViewModel {
	let publishedPokemon: Box<Pokemon?> = Box(nil)
	
	private let pokemon: Pokemon
	
	init(model: Pokemon) {
		self.pokemon = model
		
		self.setup()
	}
	
	private func setup() {
		self.publishedPokemon.value = self.pokemon
	}
}
