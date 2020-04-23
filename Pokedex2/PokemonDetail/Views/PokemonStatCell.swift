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
	private let statIndicatorView = StatIndicatorView()
	
	var viewModel: PokemonStatCellViewModel? {
		didSet {
			self.update()
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.statIndicatorView)
	}
	
	private func style() {
		self.backgroundColor = .white
		
		self.titleLabel.textColor = .lightGray
		self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
	}
	
	private func layout() {
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		let titleLabelConstraints = [
			self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.titleLabel.widthAnchor.constraint(equalToConstant: 80)
		]
		NSLayoutConstraint.activate(titleLabelConstraints)
		
		self.statIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		let statIndicatorViewConstraints = [
			self.statIndicatorView.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 32),
			self.statIndicatorView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
			self.statIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			self.statIndicatorView.heightAnchor.constraint(equalToConstant: 28)
		]
		NSLayoutConstraint.activate(statIndicatorViewConstraints)
	}
	
	private func update() {
		self.titleLabel.text = viewModel?.title
		
		self.statIndicatorView.progressValue = viewModel?.stat.baseStat
		self.statIndicatorView.trackColor = viewModel?.pokemonTypeColor.withAlphaComponent(0.2)
		self.statIndicatorView.progressBackgroundColor = viewModel?.pokemonTypeColor
	}
}
