//
//  JSONReader.swift
//  Pokedex2
//
//  Created by Michele Mola on 17/06/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import Foundation

class JSONReader {
	let fileURL: URL
	let jsonDecoder = JSONDecoder()
		
	init?(withFilename filename: String) {
		guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
			return nil
		}
		
		self.fileURL = fileURL
	}
	
	func loadModels<T: Decodable>(withType type: T.Type) throws -> [T] {
		do {
			let data = try Data(contentsOf: self.fileURL)
			let jsonData = try self.jsonDecoder.decode([T].self, from: data)
			return jsonData
		} catch {
			throw(JSONReaderError.decodingFailed)
		}
	}
}

enum JSONReaderError: String, Error {
	case decodingFailed = "Decoding failed"
}
