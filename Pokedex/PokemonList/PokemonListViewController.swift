//
//  PokemonListViewController.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit

class PokemonListViewController: UIViewController {
	/// Max number of pokemons to download from API
	static let pokemonMax = 790
	
	/// Number of pokemons per page
	static let pokemonsPerPage = 20
	
	/// Main View associated to ViewController
	let pokemonListView = PokemonListView()
	
	/// API Client to load pokemons
	let pokedexAPIClient = PokedexAPIClient()
	
	/// Download status to avoid multiple calls to API
	var isDownloading = false

	/// Pokemons collection
	var pokemons: [Pokemon] = []
	
	/// Semaphore to indicate that the first pokemon is already setted
	/// in the detail screen (iPad)
	var isFirstPokemonLoaded = false
	
	override func loadView() {
		self.view = self.pokemonListView
	}
	
	public init(viewModel: PokemonListViewModel? = nil) {
		super.init(nibName: nil, bundle: nil)
		
		self.pokemonListView.viewModel = viewModel
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupInteractions()
		
		self.loadPokemons(fromOffset: 0, withLimit: Self.pokemonsPerPage)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.title = "Pokedex"
		
		self.navigationController?.navigationBar.tintColor = .black
		self.navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.title = ""
	}
	
	private func setupInteractions() {
		self.pokemonListView.willDisplayCellAtRow = { [unowned self] row in
			let lastPokemonRow = self.pokemons.count - 1
			let numberOfPokemons = self.pokemons.count
			// Check if the collection will display the last row in order to load new contents
			// Check if there are new contents to load
			// Check if is not downloading
			if row == lastPokemonRow && numberOfPokemons < Self.pokemonMax && !self.isDownloading {
				self.loadPokemons(fromOffset: numberOfPokemons, withLimit: Self.pokemonsPerPage)
			}
		}
		
		self.pokemonListView.didSelectPokemonAtRow = { [unowned self] row in
			let pokemon = self.pokemons[row]
			
			self.showDetail(with: pokemon)
		}
	}
	
	private func showDetail(with pokemon: Pokemon) {
		let pokemonDetailViewModel = PokemonDetailViewModel(pokemon: pokemon)
		let pokemonDetailViewController = PokemonDetailViewController(viewModel: pokemonDetailViewModel)
		self.showDetailViewController(pokemonDetailViewController, sender: nil)
	}
	
	/// Load paginated pokemons references from API Client
	private func loadPokemons(fromOffset offset: Int, withLimit limit: Int) {
		self.isDownloading = true
		self.pokemonListView.viewModel = PokemonListViewModel(pokemons: self.pokemons, loaderState: .show)
		
		self.pokedexAPIClient.getPokemonList(
			withOffset: offset,
			andLimit: limit,
			completion: { [weak self] response in
				guard let self = self else { return }
				
				switch response {
					case .success(let response):
						guard let response = response else { return }
						
						self.getPokemonsDetail(from: response.results)
					
					case .failure(let error):
						print("Error: ", error)
						self.loadLocalPokemonsIfNeeded()
				}
		})
	}
	
	/// This method load the pokemons from local file "Pokemons.json"
	/// in order to show the first nine pokemons when the device is offline
	private func loadLocalPokemonsIfNeeded() {
		self.isDownloading = false
		
		if self.pokemons.isEmpty,
			 let pokemons = try? JSONReader(withFilename: "Pokemons")?.loadModels(withType: Pokemon.self)
		{
			self.pokemons.append(contentsOf: pokemons)
			self.pokemonListView.viewModel = PokemonListViewModel(pokemons: self.pokemons, loaderState: .hide)
			self.setFirstPokemonIfNeeded()
		} else {
			self.pokemonListView.viewModel = PokemonListViewModel(pokemons: self.pokemons, loaderState: .hideWithError)
		}
	}
	
	/// Get more details(types, sprites, ecc...) from pokemonReference collections
	private func getPokemonsDetail(from pokemonsReference: [PokemonReference]) {
		let dispatchGroup = DispatchGroup()
		
		pokemonsReference.forEach { [weak self] pokemonReference in
			guard let self = self else { return }
			
			dispatchGroup.enter()
			
			self.pokedexAPIClient.getPokemon(byId: pokemonReference.id) { [weak self] response in
				defer { dispatchGroup.leave() }
				
				guard let self = self else { return }
				
				switch response {
					case .success(let pokemon):
						guard let pokemon = pokemon else { return }
						self.pokemons.append(pokemon)
					
					case .failure(let error):
						print(error)
				}
			}
		}
		
		dispatchGroup.notify(queue: .main) { [weak self] in
			guard let self = self else { return }
			self.pokemons.sort { $0.id < $1.id }
			self.pokemonListView.viewModel = PokemonListViewModel(pokemons: self.pokemons, loaderState: .hide)
			self.isDownloading = false
			
			self.setFirstPokemonIfNeeded()
		}
	}
	
	/// This method load the first pokemon if the device is iPad.
	/// The interface immediatly show the first Pokemon in the detail screen.
	private func setFirstPokemonIfNeeded() {
		if Device.isIpad, !self.isFirstPokemonLoaded, let firstPokemon = self.pokemons.first {
			self.showDetail(with: firstPokemon)
			self.isFirstPokemonLoaded = true
		}
	}
}
