//
//  PokemonDetailViewModel.swift
//  Pokedex2
//
//  Created by Michele Mola on 25/04/2020.
//

import Foundation
import Combine

class PokemonDetailViewModel {
	@Published var pokemon: Pokemon?
	
	private let pokemonReference: PokemonReference
	
	private let combineAPI = CombineAPIClient()
	
	var subscriptions = Set<AnyCancellable>()
	
	init(model: PokemonReference) {
		self.pokemonReference = model
		
		self.setup()
	}
	
	private func setup() {
		self.loadPokemon(byId: self.pokemonReference.id)
	}
	
	private func loadPokemon(byId id: String) {
		self.combineAPI.getPokemon(byId: id)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { _ in },
			receiveValue: { [unowned self] pokemon in
				self.pokemon = pokemon
			})
			.store(in: &self.subscriptions)
	}
}
