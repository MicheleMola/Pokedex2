//
//  PokemonStatsCell.swift
//  Pokedex2
//
//  Created by Michele Mola on 23/04/2020.
//

import UIKit

class PokemonStatCell: UITableViewCell {
    static let reusableIdentifier = "PokemonStatsCell"
	
	
	
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
		
	}
	
	private func style() {
		self.backgroundColor = .red
	}
	
	private func layout() {
		
	}
}
