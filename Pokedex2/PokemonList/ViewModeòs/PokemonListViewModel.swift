//
//  PokemonViewModel.swift
//  Pokedex2
//
//  Created by Michele Mola on 24/04/2020.
//

import Foundation

class PokemonListViewModel {
	let publishedPokemons: Box<[Pokemon]> = Box([])
	
	let publishedIsDownloading = Box(false)
	
	// Total of pokemons to download from API
	private let pokemonMax = 790
	
	private let pokemonsPerPage = 20

	private let pokedexAPIClient = PokedexAPIClient()
	
	private var pokemons: [Pokemon] = []
	
	//Callbacks
	var showAlert: ((String, String) -> Void)?
	var didSelectPokemon: ((Pokemon) -> Void)?
	
	init() {
		self.setup()
	}
	
	private func setup() {
		self.loadPokemons(fromOffset: 0, withLimit: self.pokemonsPerPage)
	}
	
	private func loadPokemons(fromOffset offset: Int, withLimit limit: Int) {
		self.setDownloadingStatus(to: true)
		
		self.pokedexAPIClient.getPokemonList(withOffset: offset, andLimit: limit, completion: { [weak self] response in
			
			guard let self = self else { return }
			
			switch response {
				case .success(let response):
					guard let response = response else { return }
					
					self.getPokemonsDetail(from: response.results)
				
				case .failure:
					self.setDownloadingStatus(to: false)
					
					self.showAlert?("Warning", "Oops, something went wrong. Please try again later.")
			}
		})
	}
	
	private func getPokemonsDetail(from pokemonsReference: [PokemonReference]) {
		
		let dispatchGroup = DispatchGroup()
		
		pokemonsReference.forEach { pokemonReference in
			dispatchGroup.enter()
			
			self.pokedexAPIClient.getPokemon(byId: pokemonReference.id, completion: { [weak self] response in
				defer { dispatchGroup.leave() }
				
				guard let self = self else { return }
				
				switch response {
					case .success(let response):
						guard let response = response else { return }
						
						self.pokemons.append(response)
					
					case .failure(let error):
						print(error)
				}
			})
		}
		
		dispatchGroup.notify(queue: .main) {
			
			self.pokemons.sort(by: { $0.id < $1.id })
			
			self.publishedPokemons.value = self.pokemons
			
			self.setDownloadingStatus(to: false)
		}
	}
	
	private func setDownloadingStatus(to value: Bool) {
		self.publishedIsDownloading.value = value
	}

	func willDislayCell(at row: Int) {
		let numberOfPokemons = self.pokemons.count
		
		// Check if the collection will display the last row in order to load new contents
		// Check if there are new contents to load
		// Check if is downloading
		if row == numberOfPokemons - 1 && numberOfPokemons < self.pokemonMax && !self.publishedIsDownloading.value {
			self.loadPokemons(fromOffset: numberOfPokemons, withLimit: self.pokemonsPerPage)
		}
	}
	
	func didSelectCell(at row: Int) {
		let pokemon = self.pokemons[row]
		
		self.didSelectPokemon?(pokemon)
	}
}
