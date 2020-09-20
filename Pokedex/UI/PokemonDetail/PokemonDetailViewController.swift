//
//  PokemonDetailViewController.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit

class PokemonDetailViewController: UIViewController {
	/// Main View associated to ViewController
	let pokemonDetailView = PokemonDetailView()
	
	var popRecognizer: InteractivePopRecognizer?
	
	public init(viewModel: PokemonDetailViewModel? = nil) {
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
		
		self.setupInteractions()
		self.setInteractivePopRecognizer()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func setupInteractions() {
		self.pokemonDetailView.didPressBackButton = { [unowned self] in
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	private func setInteractivePopRecognizer() {
		guard let navigationController = self.navigationController else { return }
		self.popRecognizer = InteractivePopRecognizer(navigationController: navigationController)
		navigationController.interactivePopGestureRecognizer?.delegate = self.popRecognizer
	}
}
