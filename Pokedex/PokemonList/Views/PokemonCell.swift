//
//  PokemonCell.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit

struct PokemonCellViewModel {
	let pokemon: Pokemon
	
	var pokemonNameCapitalized: String {
		self.pokemon.name.capitalized
	}
	
	var pokemonId: String {
		"#\(self.pokemon.id)"
	}
	
	var pokemonSpriteFront: URL {
		self.pokemon.sprites.frontDefault
	}
	
	var primaryTypeColor: UIColor? {
		self.pokemon.primaryType?.getColor()
	}
	
	var pokemonHasTwoTypes: Bool {
		self.pokemon.types.count > 1
	}
	
	var firstType: String? {
		self.pokemon.types.first?.type.name.capitalized
	}
	
	var secondType: String? {
		self.pokemon.types.last?.type.name.capitalized
	}
}

class PokemonCell: UICollectionViewCell {
	static let reusableIdentifier = "PokemonCell"
	
	private let nameLabel = UILabel()
	private let idLabel = UILabel()
	private let pokemonImageView = UIImageView()
	private let firstTypeLabel = UILabel()
	private let secondTypeLabel = UILabel()
	
	private let whitePokeballImageView = UIImageView()
	
	var viewModel: PokemonCellViewModel? {
		didSet {
			self.update()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		self.pokemonImageView.image = nil
		self.pokemonImageView.cancelImageLoad()
		
		self.secondTypeLabel.isHidden = false
	}
	
	private func setup() {
		self.contentView.addSubview(self.nameLabel)
		self.contentView.addSubview(self.idLabel)
		
		self.contentView.addSubview(self.whitePokeballImageView)
		self.contentView.addSubview(self.pokemonImageView)
		self.contentView.addSubview(self.firstTypeLabel)
		self.contentView.addSubview(self.secondTypeLabel)
	}
	
	private func style() {
		self.contentView.layer.masksToBounds = true
		
		self.whitePokeballImageView.image = UIImage(named: "whitePokeball")
		self.whitePokeballImageView.alpha = 0.2
		
		self.pokemonImageView.contentMode = .scaleAspectFit
		
		self.nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
		self.nameLabel.textColor = .white
		
		self.idLabel.font = UIFont.boldSystemFont(ofSize: 16)
		self.idLabel.textColor = .white
		
		self.firstTypeLabel.textAlignment = .center
		self.firstTypeLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
		self.firstTypeLabel.textColor = .white
		self.firstTypeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
		self.firstTypeLabel.layer.masksToBounds = true
		
		self.secondTypeLabel.textAlignment = .center
		self.secondTypeLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
		self.secondTypeLabel.textColor = .white
		self.secondTypeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
		self.secondTypeLabel.layer.masksToBounds = true
	}
	
	private func update() {
		guard let viewModel = self.viewModel else {
			return
		}
		
		self.nameLabel.text = viewModel.pokemonNameCapitalized
		self.idLabel.text = viewModel.pokemonId
		
		self.pokemonImageView.loadImage(at: viewModel.pokemonSpriteFront)
		
		self.contentView.backgroundColor = viewModel.primaryTypeColor
		
		self.firstTypeLabel.text = viewModel.firstType
		self.secondTypeLabel.text = viewModel.secondType
		self.secondTypeLabel.isHidden = !viewModel.pokemonHasTwoTypes
	}
	
	private func layout() {
		self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
		let nameLabelConstraints = [
			self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
			self.nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		]
		NSLayoutConstraint.activate(nameLabelConstraints)
		
		self.idLabel.translatesAutoresizingMaskIntoConstraints = false
		let idLabelContraints = [
			self.idLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
			self.idLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			self.idLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor)
		]
		NSLayoutConstraint.activate(idLabelContraints)
		
		self.whitePokeballImageView.translatesAutoresizingMaskIntoConstraints = false
		let whitePokeballImageViewContraints = [
			self.whitePokeballImageView.widthAnchor.constraint(equalToConstant: 88),
			self.whitePokeballImageView.heightAnchor.constraint(equalToConstant: 88),
			self.whitePokeballImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16),
			self.whitePokeballImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8)
		]
		NSLayoutConstraint.activate(whitePokeballImageViewContraints)
		
		self.pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
		let pokemonImageViewConstraints = [
			self.pokemonImageView.widthAnchor.constraint(equalToConstant: 80),
			self.pokemonImageView.heightAnchor.constraint(equalToConstant: 80),
			self.pokemonImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.pokemonImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
		]
		NSLayoutConstraint.activate(pokemonImageViewConstraints)
		
		self.firstTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		let firstTypeLabelConstraints = [
			self.firstTypeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.firstTypeLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
			self.firstTypeLabel.heightAnchor.constraint(equalToConstant: 24),
			self.firstTypeLabel.trailingAnchor.constraint(equalTo: self.pokemonImageView.leadingAnchor, constant: -8)
		]
		NSLayoutConstraint.activate(firstTypeLabelConstraints)
		
		self.secondTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		let secondTypeLabelConstraints = [
			self.secondTypeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.secondTypeLabel.topAnchor.constraint(equalTo: self.firstTypeLabel.bottomAnchor, constant: 10),
			self.secondTypeLabel.heightAnchor.constraint(equalToConstant: 24),
			self.secondTypeLabel.trailingAnchor.constraint(equalTo: self.pokemonImageView.leadingAnchor, constant: -8)
		]
		NSLayoutConstraint.activate(secondTypeLabelConstraints)
		
		self.layoutIfNeeded()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.firstTypeLabel.layer.cornerRadius = self.firstTypeLabel.bounds.height / 2
		self.secondTypeLabel.layer.cornerRadius = self.secondTypeLabel.bounds.height / 2
		
		self.contentView.layer.cornerRadius = self.contentView.bounds.height / 10
	}
}
