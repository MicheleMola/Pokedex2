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
		return self.pokemon.stats[safeIndex: index]
	}
	
	var primaryColor: UIColor? {
		self.pokemon.primaryType?.color
	}
	
	func statisticTitle(at indexPath: IndexPath) -> String? {
		let index = indexPath.row - 1
		return StatisticTitle.allCases[safeIndex: index]?.rawValue
	}
	
	var pokemonStatsTitleCellViewModel: PokemonStatsTitleCellViewModel? {
		guard let primaryColor = self.primaryColor else { return nil }
		return PokemonStatsTitleCellViewModel(pokemonTypeColor: primaryColor)
	}
	
	func pokemonStatCellViewModel(at indexPath: IndexPath) -> PokemonStatCellViewModel? {
		guard let statistic = self.statistic(at: indexPath),
					let statisticTitle = self.statisticTitle(at: indexPath),
					let primaryColor = self.primaryColor
		else { return nil }
		
		let pokemonStatCellViewModel = PokemonStatCellViewModel(
			title: statisticTitle,
			statistic: statistic,
			pokemonTypeColor: primaryColor
		)
		
		return pokemonStatCellViewModel
	}
	
	var headerViewModel: PokemonDetailTableViewHeaderViewModel {
		PokemonDetailTableViewHeaderViewModel(pokemon: self.pokemon)
	}
}

class PokemonDetailView: UIView {
	private static let headerHeight: CGFloat = 400
	private static let cellHeight: CGFloat = 60
	private static let numberOfCells: Int = 6
	
	private let pokemonDetailTableView = UITableView(frame: .zero, style: .grouped)
	private let topGradientView = UIView()
	private let topGradientLayer: CAGradientLayer = {
		let gradientLayer = CAGradientLayer()
		gradientLayer.type = .axial
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
		gradientLayer.locations = [0.00, 0.35, 1.00]
		return gradientLayer
	}()
	
	var viewModel: PokemonDetailViewModel? {
		didSet {
			self.update(oldViewModel: oldValue)
		}
	}
	
	var didPressBackButton: (() -> ())?
					
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
		
		self.topGradientView.isUserInteractionEnabled = false
		self.topGradientView.layer.addSublayer(self.topGradientLayer)

		self.addSubview(self.pokemonDetailTableView)
		self.addSubview(self.topGradientView)
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

	private func update(oldViewModel: PokemonDetailViewModel?) {
		guard let viewModel = self.viewModel else { return }
		
		if oldViewModel?.pokemon != viewModel.pokemon {
			self.pokemonDetailTableView.reloadData()
		}
				
		self.updateGradientLayer()
	}
	
	private func updateGradientLayer() {
		guard let topColor = self.viewModel?.primaryColor?.cgColor,
					let bottomColor = self.viewModel?.primaryColor?.withAlphaComponent(0).cgColor
		else { return }
		
		self.topGradientLayer.colors = [topColor, topColor, bottomColor]
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
		
		self.topGradientView.translatesAutoresizingMaskIntoConstraints = false
		let topGradientViewConstraints = [
			self.topGradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.topGradientView.topAnchor.constraint(equalTo: self.topAnchor),
			self.topGradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.topGradientView.heightAnchor.constraint(equalToConstant: 40)
		]
		NSLayoutConstraint.activate(topGradientViewConstraints)
		
		self.layoutIfNeeded()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.topGradientLayer.frame = self.topGradientView.frame
	}
}

// MARK: - UITableViewDataSource

extension PokemonDetailView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		Self.numberOfCells
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == .zero {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonStatsTitleCell.reusableIdentifier, for: indexPath) as? PokemonStatsTitleCell else {
				fatalError("Cell: \(PokemonStatsTitleCell.reusableIdentifier) not registered")
			}
			
			cell.viewModel = viewModel?.pokemonStatsTitleCellViewModel
			
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonStatCell.reusableIdentifier, for: indexPath) as? PokemonStatCell else {
				fatalError("Cell: \(PokemonStatCell.reusableIdentifier) not registered")
			}
			
			cell.viewModel = self.viewModel?.pokemonStatCellViewModel(at: indexPath)

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
		
		headerView.viewModel = self.viewModel?.headerViewModel
		headerView.didPressBackButton = { [unowned self] in
			self.didPressBackButton?()
		}
		
		return headerView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		Self.headerHeight
	}
}
