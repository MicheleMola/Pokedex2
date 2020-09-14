//
//  PokemonDetailView.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit

struct PokemonDetailViewModel {
	let pokemon: Pokemon
}

class PokemonDetailView: UIView {
	var viewModel: PokemonDetailViewModel? {
		didSet {
			self.update()
		}
	}
	
	private let pokemonDetailTableView = UITableView(
		frame: .zero,
		style: .grouped
	)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		self.pokemonDetailTableView.dataSource = self
		self.pokemonDetailTableView.delegate = self
		self.pokemonDetailTableView.register(
			PokemonStatCell.self,
			forCellReuseIdentifier: PokemonStatCell.reusableIdentifier
		)
		self.pokemonDetailTableView.register(
			PokemonStatsTitleCell.self,
			forCellReuseIdentifier: PokemonStatsTitleCell.reusableIdentifier
		)
		
		self.addSubview(self.pokemonDetailTableView)
	}
	
	private func style() {
		self.backgroundColor = .white
		
		self.pokemonDetailTableView.backgroundColor = .white
		self.pokemonDetailTableView.separatorStyle = .none
		self.pokemonDetailTableView.bounces = false
	}
	
	private func layout() {
		self.pokemonDetailTableView.translatesAutoresizingMaskIntoConstraints = false
		let pokemonDetailTableViewConstraints = [
			self.pokemonDetailTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.pokemonDetailTableView.topAnchor.constraint(equalTo: self.topAnchor),
			self.pokemonDetailTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.pokemonDetailTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		]
		NSLayoutConstraint.activate(pokemonDetailTableViewConstraints)
	}
	
	private func update() {
		self.pokemonDetailTableView.reloadData()
	}
}

extension PokemonDetailView: UITableViewDataSource {
	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		return 7
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier: PokemonStatsTitleCell.reusableIdentifier, for: indexPath) as! PokemonStatsTitleCell
				
				if let pokemonTypeColor = viewModel?.pokemon.primaryType?.getColor() {
					cell.viewModel = PokemonStatsTitleCellViewModel(pokemonTypeColor: pokemonTypeColor)
				}
				
				return cell
			case 1...6:
				let cell = tableView.dequeueReusableCell(withIdentifier: PokemonStatCell.reusableIdentifier, for: indexPath) as! PokemonStatCell
				
				let index = indexPath.row - 1
				if let stat = viewModel?.pokemon.stats[index], let primaryTypeColor = viewModel?.pokemon.primaryType?.getColor() {
					let pokemonStatCellViewModel = PokemonStatCellViewModel(title: StatTitle.allCases[index].rawValue, stat: stat, pokemonTypeColor: primaryTypeColor)
					
					cell.viewModel = pokemonStatCellViewModel
				}
				
				return cell
			default: return UITableViewCell()
		}
	}
}

extension PokemonDetailView: UITableViewDelegate {
	func tableView(
		_ tableView: UITableView,
		heightForRowAt indexPath: IndexPath
	) -> CGFloat {
		switch indexPath.row {
			case 0...6: return 60
			default: return 0
		}
	}
	
	func tableView(
		_ tableView: UITableView,
		viewForHeaderInSection section: Int
	) -> UIView? {
		let headerView = PokemonDetailTableViewHeader()
		
		if let pokemon = viewModel?.pokemon {
			headerView.viewModel = PokemonDetailTableViewHeaderViewModel(pokemon: pokemon)
		}
		
		return headerView
	}
	
	func tableView(
		_ tableView: UITableView,
		heightForHeaderInSection section: Int
	) -> CGFloat {
		return 400
	}
}

enum StatTitle: String, CaseIterable {
	case speed = "Speed"
	case speedDefense = "Sp.Def"
	case speedAttack = "Sp.Atk"
	case defense = "Defense"
	case attack = "Attack"
	case hp = "HP"
}
