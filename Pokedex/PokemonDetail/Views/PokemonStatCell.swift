//
//  PokemonStatsCell.swift
//  Pokedex2
//
//  Created by Michele Mola on 23/04/2020.
//

import UIKit

struct PokemonStatCellViewModel {
	let title: String
	let stat: StatResponse
	let pokemonTypeColor: UIColor
}

class PokemonStatCell: UITableViewCell {
	static let reusableIdentifier = "PokemonStatCell"
	
	private let titleLabel = UILabel()
	private let statisticIndicatorView = StatisticIndicatorView()
	
	var viewModel: PokemonStatCellViewModel? {
		didSet {
			self.update()
		}
	}
	
	override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier: String?
	) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup

	private func setup() {
		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.statisticIndicatorView)
	}
	
	// MARK: - Style

	private func style() {
		self.backgroundColor = .white
		
		self.titleLabel.textColor = .lightGray
		self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
	}
	
	// MARK: - Update

	private func update() {
		guard let viewModel = self.viewModel else { return }
		
		self.titleLabel.text = viewModel.title
		
		self.statisticIndicatorView.progressValue = viewModel.stat.baseStat
		self.statisticIndicatorView.trackColor = viewModel.pokemonTypeColor.withAlphaComponent(0.2)
		self.statisticIndicatorView.progressBackgroundColor = viewModel.pokemonTypeColor
	}
	
	// MARK: - Layout

	private func layout() {
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		let titleLabelConstraints = [
			self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
			self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
			self.titleLabel.widthAnchor.constraint(equalToConstant: 80)
		]
		NSLayoutConstraint.activate(titleLabelConstraints)
		
		self.statisticIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		let statIndicatorViewConstraints = [
			self.statisticIndicatorView.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 32),
			self.statisticIndicatorView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
			self.statisticIndicatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
			self.statisticIndicatorView.heightAnchor.constraint(equalToConstant: 28)
		]
		NSLayoutConstraint.activate(statIndicatorViewConstraints)
	}
}
