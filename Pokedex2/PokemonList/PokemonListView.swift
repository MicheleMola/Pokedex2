//
//  PokemonListView.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit

class PokemonListView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		
	}
	
	private func style() {
		self.backgroundColor = .red
	}
	
	private func layout() {
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.layout()
	}
}
