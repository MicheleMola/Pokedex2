//
//  FooterPokemonsCollectionView.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit

class PokemonsCollectionViewFooter: UICollectionReusableView {
	static let reusableIdentifier = "PokemonsCollectionViewFooter"
	
	private let pokeBallLoader = PokeBallLoader()
	private let errorLabel = UILabel()
	
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
		self.addSubview(self.pokeBallLoader)
		self.addSubview(self.errorLabel)
	}
	
	private func style() {
		self.errorLabel.text = "Check your connection..."
		self.errorLabel.textColor = .gray
		self.errorLabel.textAlignment = .center
		self.errorLabel.font = UIFont.boldSystemFont(ofSize: 16)
		
		self.errorLabel.alpha = 0
	}
	
	private func layout() {
		self.pokeBallLoader.translatesAutoresizingMaskIntoConstraints = false
		let pokeBallLoaderConstraints = [
			self.pokeBallLoader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.pokeBallLoader.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.pokeBallLoader.widthAnchor.constraint(equalToConstant: 50),
			self.pokeBallLoader.heightAnchor.constraint(equalToConstant: 50)
		]
		NSLayoutConstraint.activate(pokeBallLoaderConstraints)
		
		self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
		let errorLabelContraints = [
			self.errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.errorLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
			self.errorLabel.heightAnchor.constraint(equalToConstant: 50)
		]
		NSLayoutConstraint.activate(errorLabelContraints)
	}
	
	func showLoader() {
		self.errorLabel.alpha = 0
		self.pokeBallLoader.show()
	}
	
	func hideLoader() {
		self.errorLabel.alpha = 0
		self.pokeBallLoader.dismiss()
	}
	
	func hideLoaderWithError() {
		self.pokeBallLoader.dismiss()
		self.errorLabel.alpha = 1
	}
}
