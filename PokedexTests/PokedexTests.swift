//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by Michele Mola on 15/09/20.
//

import XCTest

@testable import Pokedex

class PokedexTests: XCTestCase {
	
	let pokedexAPIClient = PokedexAPIClient()
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testValidGetPokemonCall() {
		let promise = expectation(description: "Download pokemon completed")
		
		self.pokedexAPIClient.getPokemon(byId: "20") { result in
			switch result {
				case .success(_):
					promise.fulfill()
				case .failure(let error):
					XCTFail("Error: \(error.localizedDescription)")
			}
		}
		
		wait(for: [promise], timeout: 5)
	}
	
	func testValidGetPokemonsCall() {
		let promise = expectation(description: "Download pokemons completed")

		self.pokedexAPIClient.getPokemonList(withOffset: 0, andLimit: 20) { result in
			switch result {
				case .success(_):
					promise.fulfill()
				case .failure(let error):
					XCTFail("Error: \(error.localizedDescription)")
			}
		}
		
		wait(for: [promise], timeout: 5)
	}
	
	func testValidGetPokemonsDetailFromReferences() {
		let pokemonsReference: [PokemonReference] = [
			PokemonReference(name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!),
			PokemonReference(name: "ivysaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!),
			PokemonReference(name: "venusaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/3/")!)
		]
		
		let dispatchGroup = DispatchGroup()
		var pokemons: [Pokemon] = []
		
		pokemonsReference.forEach { pokemonReference in
			dispatchGroup.enter()
			
			self.pokedexAPIClient.getPokemon(byId: pokemonReference.id) { response in
				defer { dispatchGroup.leave() }
								
				switch response {
					case .success(let response):
						guard let response = response else { return }
						
						pokemons.append(response)
					
					case .failure(let error):
						print("Error: \(error.localizedDescription)")
				}
			}
		}
		
		dispatchGroup.notify(queue: .main) {
			XCTAssertEqual(pokemonsReference.count, pokemons.count)
		}
	}
	
	func testValidGetPokemonURLCreation() {
		let urlMock = URL(string: "https://pokeapi.co/api/v2/pokemon/1?")!
		let url = PokedexAPI.getPokemon(id: "1").request.url!
		
		XCTAssertEqual(urlMock, url)
	}
	
	func testValidGetPokemonsURLCreation() {
		let urlMock = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20")!
		let url = PokedexAPI.getPokemonList(offset: 0, limit: 20).request.url!
		
		XCTAssertEqual(urlMock, url)
	}
	
	func testDecodePokemon() {
		let pokemonMock = Pokemon(
			name: "bulbasaur",
			id: 1,
			types: [],
			sprites: Sprites(frontDefault: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!),
			stats: []
		)
		
		let request = PokedexAPI.getPokemon(id: "1").request
		self.pokedexAPIClient.fetch(
			with: request,
			decode: { json -> Pokemon? in
				guard let response = json as? Pokemon else { return nil }
				return response
			}, completion: { result in
				switch result {
					case .success(let pokemon):
						XCTAssertEqual(pokemon, pokemonMock)
					case .failure(let error):
						XCTFail("Error: \(error.localizedDescription)")
				}
			})
	}
}
