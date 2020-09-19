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
	
	var pokemonSpriteFrontURL: URL {
		self.pokemon.sprites.frontDefault
	}
	
	var primaryTypeColor: UIColor? {
		self.pokemon.primaryType?.color
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
	
	var placeholderImage: UIImage? {
		UIImage(named: "PokemonsSprites/\(self.pokemon.id)")
	}
	
	var isHiddenSecondType: Bool {
		!self.pokemonHasTwoTypes
	}
}

class PokemonCell: UICollectionViewCell {
	static let reusableIdentifier = "PokemonCell"
	
	private let nameLabel = UILabel()
	private let idLabel = UILabel()
	private let pokemonImageView = AsyncLoadImageView()
	private let firstTypeLabel = UILabel()
	private let secondTypeLabel = UILabel()
	private let whitePokeballImageView = UIImageView()
	
	var viewModel: PokemonCellViewModel? {
		didSet {
			self.update()
		}
	}
	private var oldViewModel: PokemonCellViewModel?
	
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
		
		self.pokemonImageView.cancelLoad()
		self.pokemonImageView.image = nil

		self.secondTypeLabel.isHidden = false
	}
	
	// MARK: - Setup

	private func setup() {
		self.contentView.addSubview(self.nameLabel)
		self.contentView.addSubview(self.idLabel)
		self.contentView.addSubview(self.whitePokeballImageView)
		self.contentView.addSubview(self.pokemonImageView)
		self.contentView.addSubview(self.firstTypeLabel)
		self.contentView.addSubview(self.secondTypeLabel)
	}
	
	// MARK: - Style

	private func style() {
		self.contentView.layer.masksToBounds = true
		
		self.whitePokeballImageView.image = UIImage(named: "whitePokeball")
		self.whitePokeballImageView.alpha = 0.2
		
		self.pokemonImageView.contentMode = .scaleAspectFill
		
		self.nameLabel.font = UIFont.boldSystemFont(ofSize: 19)
		self.nameLabel.textColor = .white
		
		self.idLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		self.idLabel.textColor = .black
		
		self.firstTypeLabel.textAlignment = .center
		self.firstTypeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		self.firstTypeLabel.textColor = .white
		self.firstTypeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
		self.firstTypeLabel.layer.masksToBounds = true
		
		self.secondTypeLabel.textAlignment = .center
		self.secondTypeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		self.secondTypeLabel.textColor = .white
		self.secondTypeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
		self.secondTypeLabel.layer.masksToBounds = true
	}
	
	// MARK: - Update

	private func update() {
		guard let viewModel = self.viewModel else {
			return
		}
		
		defer {
			self.oldViewModel = viewModel
		}
		
		self.contentView.backgroundColor = viewModel.primaryTypeColor
		
		self.nameLabel.text = viewModel.pokemonNameCapitalized
		self.idLabel.text = viewModel.pokemonId
		
		self.pokemonImageView.loadImage(at: viewModel.pokemonSpriteFrontURL, withPlaceholderImage: viewModel.placeholderImage)
		
		self.firstTypeLabel.text = viewModel.firstType
		
		self.secondTypeLabel.text = viewModel.secondType
		self.secondTypeLabel.isHidden = viewModel.isHiddenSecondType
	}
	
	// MARK: - Layout

	private func layout() {
		self.idLabel.translatesAutoresizingMaskIntoConstraints = false
		let idLabelContraints = [
			self.idLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
			self.idLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
			self.idLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
		]
		NSLayoutConstraint.activate(idLabelContraints)
		
		self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
		let nameLabelConstraints = [
			self.nameLabel.topAnchor.constraint(equalTo: self.idLabel.bottomAnchor, constant: 8),
			self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
		]
		NSLayoutConstraint.activate(nameLabelConstraints)
		
		self.whitePokeballImageView.translatesAutoresizingMaskIntoConstraints = false
		let whitePokeballImageViewContraints = [
			self.whitePokeballImageView.widthAnchor.constraint(equalToConstant: 88),
			self.whitePokeballImageView.heightAnchor.constraint(equalToConstant: 88),
			self.whitePokeballImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 16),
			self.whitePokeballImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
		]
		NSLayoutConstraint.activate(whitePokeballImageViewContraints)
		
		self.pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
		let pokemonImageViewConstraints = [
			self.pokemonImageView.widthAnchor.constraint(equalToConstant: 80),
			self.pokemonImageView.heightAnchor.constraint(equalToConstant: 80),
			self.pokemonImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
			self.pokemonImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
		]
		NSLayoutConstraint.activate(pokemonImageViewConstraints)
		
		self.firstTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		let firstTypeLabelConstraints = [
			self.firstTypeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
			self.firstTypeLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8),
			self.firstTypeLabel.heightAnchor.constraint(equalToConstant: 28),
			self.firstTypeLabel.widthAnchor.constraint(equalToConstant: 68),
		]
		NSLayoutConstraint.activate(firstTypeLabelConstraints)
		
		self.secondTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		let secondTypeLabelConstraints = [
			self.secondTypeLabel.leadingAnchor.constraint(equalTo: self.firstTypeLabel.trailingAnchor, constant: 8),
			self.secondTypeLabel.centerYAnchor.constraint(equalTo: self.firstTypeLabel.centerYAnchor),
			self.secondTypeLabel.heightAnchor.constraint(equalToConstant: 28),
			self.secondTypeLabel.widthAnchor.constraint(equalToConstant: 68)
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
