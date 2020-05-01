//
//  PokemonCell.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit
import Combine

struct PokemonCellViewModel {
	private let pokemonReference: PokemonReference
	
	init(pokemonReference: PokemonReference) {
		self.pokemonReference = pokemonReference
	}
	
	var id: String {
		return "#\(self.pokemonReference.id)"
	}
	
	var name: String {
		return self.pokemonReference.name.capitalized
	}
	
	var spriteURL: URL? {
		return self.pokemonReference.spriteURL
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
		
	private var subscription: AnyCancellable?
	
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
		
		self.subscription?.cancel()
	}
	
	private func setup() {
		self.contentView.addSubview(self.nameLabel)
		self.contentView.addSubview(self.idLabel)
		self.contentView.addSubview(self.whitePokeballImageView)
		self.contentView.addSubview(self.pokemonImageView)
	}
	
	private func style() {
		self.contentView.layer.masksToBounds = true
		
		self.contentView.backgroundColor = UIColor(red: 223/255, green: 94/255, blue: 86/255, alpha: 1)

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
		
		self.nameLabel.text = viewModel.name
		self.idLabel.text = viewModel.id
		
		if let spriteURL = viewModel.spriteURL {
			self.subscription = CombineImageLoader.load(from: spriteURL)
				.receive(on: DispatchQueue.main)
				.assign(to: \.image, on: self.pokemonImageView)
		}
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
			self.pokemonImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.pokemonImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
		]
		NSLayoutConstraint.activate(pokemonImageViewConstraints)
		
		self.layoutIfNeeded()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.firstTypeLabel.layer.cornerRadius = self.firstTypeLabel.bounds.height / 2
		self.secondTypeLabel.layer.cornerRadius = self.secondTypeLabel.bounds.height / 2
		
		self.contentView.layer.cornerRadius = self.contentView.bounds.height / 10
	}
}
