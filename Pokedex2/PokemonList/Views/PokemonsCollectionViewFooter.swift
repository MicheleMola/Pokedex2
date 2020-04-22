//
//  FooterPokemonsCollectionView.swift
//  Pokedex2
//
//  Created by Michele Mola on 22/04/2020.
//

import UIKit

class PokemonsCollectionViewFooter: UICollectionReusableView {
    static let reusableIdentifier = "PokemonsCollectionViewFooter"
	
	let pokeBallLoader = PokeBallLoader()
	
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
	}
	
	private func style() {}
	
	private func layout() {
		self.pokeBallLoader.translatesAutoresizingMaskIntoConstraints = false

		let constraints = [
			self.pokeBallLoader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.pokeBallLoader.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.pokeBallLoader.widthAnchor.constraint(equalToConstant: 50),
			self.pokeBallLoader.heightAnchor.constraint(equalToConstant: 50)
		]
		NSLayoutConstraint.activate(constraints)
	}
	
	func showLoader() {
		self.pokeBallLoader.show()
	}
	
	func hideLoader() {
		self.pokeBallLoader.dismiss()
	}
}
