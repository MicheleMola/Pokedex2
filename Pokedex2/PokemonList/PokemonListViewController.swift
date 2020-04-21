//
//  PokemonListViewController.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit

class PokemonListViewController: UIViewController {
	let pokemonListView = PokemonListView()
	
	override func loadView() {
		self.view = self.pokemonListView
	}
}
