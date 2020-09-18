//
//  PokemonDetailViewController.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit

class PokemonDetailViewController: UIViewController {
	let pokemonDetailView = PokemonDetailView()
	
	public init(viewModel: PokemonDetailViewModel?) {
		super.init(nibName: nil, bundle: nil)
		
		self.pokemonDetailView.viewModel = viewModel
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		self.view = self.pokemonDetailView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBar.prefersLargeTitles = false
	}
}
