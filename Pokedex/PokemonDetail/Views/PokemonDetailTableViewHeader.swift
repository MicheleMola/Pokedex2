//
//  PokemonDetailTableViewHeader.swift
//  Pokedex2
//
//  Created by Michele Mola on 23/04/2020.
//

import UIKit

struct PokemonDetailTableViewHeaderViewModel {
	let pokemon: Pokemon
	
	var pokemonNameCapitalized: String {
		self.pokemon.name.capitalized
	}
	
	var pokemonId: String {
		"#\(self.pokemon.id)"
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
	
	var pokemonImageURL: URL? {
		self.pokemon.imageURL
	}
	
	var placeholderImage: UIImage? {
		UIImage(named: "Hd/\(self.pokemon.id)")
	}
}

class PokemonDetailTableViewHeader: UIView {
	static let reusableIdentifier = "PokemonDetailTableViewHeader"
	
	var viewModel: PokemonDetailTableViewHeaderViewModel? {
		didSet {
			self.update()
		}
	}
	
	private var oldViewModel: PokemonDetailTableViewHeaderViewModel?
	
	private let whitePokeballImageView = UIImageView()
	private let pokemonImageView = AsyncLoadImageView()
	private let nameLabel = UILabel()
	private let idLabel = UILabel()
	private let firstTypeLabel = UILabel()
	private let secondTypeLabel = UILabel()
	
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
		self.addSubview(self.whitePokeballImageView)
		self.addSubview(self.pokemonImageView)
		self.addSubview(self.nameLabel)
		self.addSubview(self.idLabel)
		self.addSubview(self.firstTypeLabel)
		self.addSubview(self.secondTypeLabel)
	}
	
	private func style() {
		self.whitePokeballImageView.image = UIImage(named: "whitePokeball")
		self.whitePokeballImageView.contentMode = .scaleAspectFit
		self.whitePokeballImageView.alpha = 0.4
		
		self.nameLabel.font = UIFont.boldSystemFont(ofSize: 26)
		self.nameLabel.textColor = .white
		
		self.idLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
		self.idLabel.textColor = .black
		
		self.firstTypeLabel.layer.masksToBounds = true
		self.firstTypeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
		self.firstTypeLabel.textAlignment = .center
		self.firstTypeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		self.firstTypeLabel.textColor = .white
		
		self.secondTypeLabel.layer.masksToBounds = true
		self.secondTypeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
		self.secondTypeLabel.textAlignment = .center
		self.secondTypeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		self.secondTypeLabel.textColor = .white
	}
	
	private func update() {
		guard let viewModel = self.viewModel else {
			return
		}
		
		defer {
			self.oldViewModel = viewModel
		}
		
		self.backgroundColor = viewModel.primaryTypeColor
		
		self.nameLabel.text = viewModel.pokemonNameCapitalized
		self.idLabel.text = viewModel.pokemonId
		
		self.firstTypeLabel.text = viewModel.firstType
		self.secondTypeLabel.text = viewModel.secondType
		self.secondTypeLabel.isHidden = !viewModel.pokemonHasTwoTypes
		
		if
			self.oldViewModel?.pokemonImageURL != viewModel.pokemonImageURL,
			let imageURL = viewModel.pokemonImageURL
		{
			self.pokemonImageView.loadImage(at: imageURL, withPlaceholderImage: viewModel.placeholderImage, animated: true)
		}
	}
	
	private func layout() {
		self.whitePokeballImageView.translatesAutoresizingMaskIntoConstraints = false
		let whitePokeballImageViewConstraints = [
			self.whitePokeballImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 100),
			self.whitePokeballImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 32),
			self.whitePokeballImageView.widthAnchor.constraint(equalToConstant: 367),
			self.whitePokeballImageView.heightAnchor.constraint(equalToConstant: 220)
		]
		NSLayoutConstraint.activate(whitePokeballImageViewConstraints)
		
		self.pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
		let pokemonImageViewConstraints = [
			self.pokemonImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			self.pokemonImageView.widthAnchor.constraint(equalToConstant: 160),
			self.pokemonImageView.heightAnchor.constraint(equalToConstant: 160),
			self.pokemonImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		]
		NSLayoutConstraint.activate(pokemonImageViewConstraints)
		
		self.idLabel.translatesAutoresizingMaskIntoConstraints = false
		let idLabelConstraints = [
			self.idLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
			self.idLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 96)
		]
		NSLayoutConstraint.activate(idLabelConstraints)
		
		self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
		let nameLabelConstraints = [
			self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 96),
			self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
			self.nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor)
		]
		NSLayoutConstraint.activate(nameLabelConstraints)
		
		self.firstTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		let firstTypeLabelConstraints = [
			self.firstTypeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
			self.firstTypeLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 16),
			self.firstTypeLabel.widthAnchor.constraint(equalToConstant: 100),
			self.firstTypeLabel.heightAnchor.constraint(equalToConstant: 32)
		]
		NSLayoutConstraint.activate(firstTypeLabelConstraints)
		
		self.secondTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		let secondTypeLabelConstraints = [
			self.secondTypeLabel.leadingAnchor.constraint(equalTo: self.firstTypeLabel.trailingAnchor, constant: 16),
			self.secondTypeLabel.topAnchor.constraint(equalTo: self.firstTypeLabel.topAnchor),
			self.secondTypeLabel.widthAnchor.constraint(equalToConstant: 100),
			self.secondTypeLabel.heightAnchor.constraint(equalToConstant: 32)
		]
		NSLayoutConstraint.activate(secondTypeLabelConstraints)
		
		self.layoutIfNeeded()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.firstTypeLabel.layer.cornerRadius = self.firstTypeLabel.bounds.height / 2
		self.secondTypeLabel.layer.cornerRadius = self.secondTypeLabel.bounds.height / 2
	}
}
