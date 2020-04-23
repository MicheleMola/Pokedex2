//
//  PokemonListViewController.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit

class PokemonListViewController: UIViewController {
	let pokemonListView = PokemonListView()
	
	let pokedexAPIClient = PokedexAPIClient()
	
	var isDownloading = false
	
	// Total of pokemons to download from API
	let pokemonMax = 790
	
	var pokemons: [Pokemon] = []
	
	let pokemonsPerPage = 20
	
	override func loadView() {
		self.view = self.pokemonListView
	}
	
	public init(viewModel: PokemonListViewModel?) {
		super.init(nibName: nil, bundle: nil)
		
		self.pokemonListView.viewModel = viewModel
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupInteractions()
		
		self.loadPokemons(fromOffset: 0, withLimit: self.pokemonsPerPage)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.title = "Pokedex"
		self.navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func setupInteractions() {
		
		self.pokemonListView.willDisplayCellAtRow = { [unowned self] row in
			let numberOfPokemons = self.pokemons.count
			
			// Check if the collection will display the last row in order to load new contents
			// Check if there are new contents to load
			// Check if is downloading
			if row == numberOfPokemons - 1 && numberOfPokemons < self.pokemonMax && !self.isDownloading {
				
				self.loadPokemons(fromOffset: numberOfPokemons, withLimit: self.pokemonsPerPage)
			}
		}
		
		self.pokemonListView.didSelectPokemonAtRow = { [unowned self] row in
			let pokemon = self.pokemons[row]
			
			let pokemonDetailViewModel = PokemonDetailViewModel(pokemon: pokemon)
			let pokemonDetailViewController = PokemonDetailViewController(viewModel: pokemonDetailViewModel)
			
			self.present(pokemonDetailViewController, animated: true, completion: nil)
		}
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
					
					self.showAlert(withTitle: "Warning", andMessage: "Oops, something went wrong. Please try again later.")
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
			
			self.pokemonListView.viewModel = PokemonListViewModel(pokemons: self.pokemons)
			
			self.setDownloadingStatus(to: false)
		}
	}
	
	private func setDownloadingStatus(to value: Bool) {
		self.isDownloading = value
		
		self.pokemonListView.isDownloading = value
	}
}
