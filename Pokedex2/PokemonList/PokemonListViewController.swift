//
//  PokemonListViewController.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit

class PokemonListViewController: UIViewController {
	
	private let pokemonListViewModel = PokemonListViewModel()
	
	override func loadView() {
		self.view = PokemonListView(viewModel: self.pokemonListViewModel)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupInteractions()
		self.setupVMCallbacks()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.title = "Pokedex"
		self.navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func setupInteractions() {
		
		(self.view as! PokemonListView).willDisplayCellAtRow = { [unowned self] row in
			self.pokemonListViewModel.willDislayCell(at: row)
		}
		
		(self.view as! PokemonListView).didSelectPokemonAtRow = { [unowned self] row in
			self.pokemonListViewModel.didSelectCell(at: row)
		}
	}
	
	private func setupVMCallbacks() {
		self.pokemonListViewModel.showAlert = { [unowned self] title, message in
			self.showAlert(withTitle: title, andMessage: message)
		}
		
		self.pokemonListViewModel.didSelectPokemon = { [unowned self] pokemon in
//			let pokemonDetailViewModel = PokemonDetailViewModel(pokemon: pokemon)
			let pokemonDetailViewController = PokemonDetailViewController(model: pokemon)
			
			self.present(pokemonDetailViewController, animated: true, completion: nil)
		}
	}
}
