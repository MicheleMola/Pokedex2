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
	
	func getColor() -> UIColor {
		switch self {
		case .fire:
			return fireColor
		case .flying:
			return flyingColor
		case .normal:
			return normalColor
		case .water:
			return waterColor
		case .grass:
			return grassColor
		case .electric:
			return electricColor
		case .ice:
			return iceColor
		case .fighting:
			return fightingColor
		case .poison:
			return poisonColor
		case .ground:
			return groundColor
		case .psychic:
			return psychicColor
		case .bug:
			return bugColor
		case .rock:
			return rockColor
		case .ghost:
			return ghostColor
		case .dark:
			return darkColor
		case .dragon:
			return dragonColor
		case .steel:
			return steelColor
		case .fairy:
			return fairyColor
		}
	}
}
