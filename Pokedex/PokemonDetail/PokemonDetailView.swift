//
//  PokemonDetailView.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit

enum StatisticTitle: String, CaseIterable {
	case speed = "Speed"
	case speedDefense = "Sp.Def"
	case speedAttack = "Sp.Atk"
	case defense = "Defense"
	case attack = "Attack"
	case hp = "HP"
}

struct PokemonDetailViewModel {
	let pokemon: Pokemon
	
	func statistic(at indexPath: IndexPath) -> StatResponse? {
		let index = indexPath.row - 1
		return self.pokemon.stats[index]
	}
	
	var primaryColor: UIColor? {
		self.pokemon.primaryType?.color
	}
	
	func statisticTitle(at indexPath: IndexPath) -> String {
		let index = indexPath.row - 1
		return StatisticTitle.allCases[index].rawValue
	}
}

class PokemonDetailView: UIView {
	private static let headerHeight: CGFloat = 400
	private static let cellHeight: CGFloat = 60
	private static let numberOfCells: Int = 6
	
	private let pokemonDetailTableView = UITableView(frame: .zero, style: .grouped)
	
	var viewModel: PokemonDetailViewModel? {
		didSet {
			self.update()
		}
	}
	var oldViewModel: PokemonDetailViewModel?
					
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup

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
	
	// MARK: - Style

	private func style() {
		self.backgroundColor = .white
		
		self.pokemonDetailTableView.backgroundColor = .white
		self.pokemonDetailTableView.separatorStyle = .none
		self.pokemonDetailTableView.bounces = false
		self.pokemonDetailTableView.allowsSelection = false
		self.pokemonDetailTableView.contentInsetAdjustmentBehavior = .never
	}
	
	// MARK: - Update

	private func update() {
		guard let viewModel = self.viewModel else { return }
		
		defer {
			self.oldViewModel = viewModel
		}
		
		if self.oldViewModel?.pokemon != viewModel.pokemon {
			self.pokemonDetailTableView.reloadData()
		}
	}
	
	// MARK: - Layout

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
}

// MARK: - UITableViewDataSource

extension PokemonDetailView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		Self.numberOfCells
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = self.viewModel else { return UITableViewCell() }
		
		if indexPath.row == .zero {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonStatsTitleCell.reusableIdentifier, for: indexPath) as? PokemonStatsTitleCell else {
				fatalError("Cell not registered")
			}
			
			if let pokemonTypeColor = viewModel.primaryColor {
				cell.viewModel = PokemonStatsTitleCellViewModel(pokemonTypeColor: pokemonTypeColor)
			}
			
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonStatCell.reusableIdentifier, for: indexPath) as? PokemonStatCell else {
				fatalError("Cell not registered")
			}
			
			if let stat = viewModel.statistic(at: indexPath), let primaryTypeColor = viewModel.primaryColor {
				let pokemonStatCellViewModel = PokemonStatCellViewModel(
					title: viewModel.statisticTitle(at: indexPath),
					stat: stat,
					pokemonTypeColor: primaryTypeColor
				)
				
				cell.viewModel = pokemonStatCellViewModel
			}
			
			return cell
		}
	}
}

// MARK: - UITableViewDelegate

extension PokemonDetailView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Self.cellHeight
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = PokemonDetailTableViewHeader()
		
		if let pokemon = viewModel?.pokemon {
			headerView.viewModel = PokemonDetailTableViewHeaderViewModel(pokemon: pokemon)
		}
		
		return headerView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		Self.headerHeight
	}
}
