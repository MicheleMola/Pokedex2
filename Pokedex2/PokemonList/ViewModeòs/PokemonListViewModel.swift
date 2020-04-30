//
//  PokemonViewModel.swift
//  Pokedex2
//
//  Created by Michele Mola on 24/04/2020.
//

import Foundation
import Combine

class PokemonListViewModel {
	@Published var pokemons: [PokemonReference] = []
	@Published var isDownloading = false
	
	// Total of pokemons to download from API
	private let pokemonMax = 780
	
	private let pokemonsPerPage = 20
	
	private let combineAPI = CombineAPIClient()
	
	//Callbacks
	var showAlert: ((String, String) -> Void)?
	var didSelectPokemon: ((PokemonReference) -> Void)?
	
	var subscriptions = Set<AnyCancellable>()

	init() {
		self.setup()
	}
	
	private func setup() {
		self.loadPokemons(fromOffset: 0, withLimit: self.pokemonsPerPage)
	}
		
	private func loadPokemons(fromOffset offset: Int, withLimit limit: Int) {
		self.isDownloading = true
		
		self.combineAPI.getPokemons(withOffset: offset, andLimit: limit)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { _ in
				self.isDownloading = false
			},
			receiveValue: { pokemons in
				self.pokemons.append(contentsOf: pokemons)
			})
			.store(in: &subscriptions)
	}
	
	func willDislayCell(at row: Int) {
		let numberOfPokemons = self.pokemons.count
		
		// Check if the collection will display the last row in order to load new contents
		// Check if there are new contents to load
		// Check if is downloading
		if row == numberOfPokemons - 1 && numberOfPokemons <= self.pokemonMax && !self.isDownloading {
			self.loadPokemons(fromOffset: numberOfPokemons, withLimit: self.pokemonsPerPage)
		}
	}
	
	func didSelectCell(at row: Int) {
		let pokemonReference = self.pokemons[row]
	
		self.didSelectPokemon?(pokemonReference)
	}
}
