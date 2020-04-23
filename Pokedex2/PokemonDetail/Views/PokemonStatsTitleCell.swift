//
//  PokemonStatsTitleCell.swift
//  Pokedex2
//
//  Created by Michele Mola on 23/04/2020.
//

import UIKit

struct PokemonStatsTitleCellViewModel {
	let pokemonTypeColor: UIColor
}

class PokemonStatsTitleCell: UITableViewCell {
	static let reusableIdentifier = "PokemonStatsTitleCell"
	
	private let roundedContainer = UIView()
	private let titleLabel = UILabel()
	
	var viewModel: PokemonStatsTitleCellViewModel? {
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
		self.contentView.addSubview(self.roundedContainer)
		self.contentView.addSubview(self.titleLabel)
	}
	
	private func style() {
		self.roundedContainer.layer.masksToBounds = true
		self.roundedContainer.backgroundColor = .white
		
		self.titleLabel.text = "Stats"
		self.titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
	}
	
	private func layout() {
		self.roundedContainer.translatesAutoresizingMaskIntoConstraints = false
		let roundedContainerConstraints = [
			self.roundedContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.roundedContainer.topAnchor.constraint(equalTo: self.topAnchor),
			self.roundedContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.roundedContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		]
		NSLayoutConstraint.activate(roundedContainerConstraints)
		
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		let titleLabelConstraints = [
			self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor)
		]
		NSLayoutConstraint.activate(titleLabelConstraints)
		
		self.layoutIfNeeded()
	}
	
	private func update() {
		self.contentView.backgroundColor = viewModel?.pokemonTypeColor
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.roundedContainer.roundCorners(corners: [.topLeft, .topRight], radius: self.roundedContainer.bounds.height / 3)
	}
}

