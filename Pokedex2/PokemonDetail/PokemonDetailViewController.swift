//
//  PokemonDetailViewController.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit

class PokemonDetailViewController: UIViewController {
	var pokemonDetailViewModel: PokemonDetailViewModel
	
	public init(model: Pokemon) {
		self.pokemonDetailViewModel = PokemonDetailViewModel(model: model)

		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		self.view = PokemonDetailView(viewModel: self.pokemonDetailViewModel)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
