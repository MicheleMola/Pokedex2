//
//  PokemonType.swift
//  Pokedex
//
//  Created by Michele Mola on 26/03/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

enum PokemonType: String {
	case fire
	case flying
	case normal
	case water
	case grass
	case electric
	case ice
	case fighting
	case poison
	case ground
	case psychic
	case bug
	case rock
	case ghost
	case dark
	case dragon
	case steel
	case fairy
	
	var color: UIColor {
		switch self {
			case .fire:
				return PokemonColor.fireColor
			case .flying:
				return PokemonColor.flyingColor
			case .normal:
				return PokemonColor.normalColor
			case .water:
				return PokemonColor.waterColor
			case .grass:
				return PokemonColor.grassColor
			case .electric:
				return PokemonColor.electricColor
			case .ice:
				return PokemonColor.iceColor
			case .fighting:
				return PokemonColor.fightingColor
			case .poison:
				return PokemonColor.poisonColor
			case .ground:
				return PokemonColor.groundColor
			case .psychic:
				return PokemonColor.psychicColor
			case .bug:
				return PokemonColor.bugColor
			case .rock:
				return PokemonColor.rockColor
			case .ghost:
				return PokemonColor.ghostColor
			case .dark:
				return PokemonColor.darkColor
			case .dragon:
				return PokemonColor.dragonColor
			case .steel:
				return PokemonColor.steelColor
			case .fairy:
				return PokemonColor.fairyColor
		}
	}
}
