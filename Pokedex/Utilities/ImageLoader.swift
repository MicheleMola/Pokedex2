//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Michele Mola on 03/04/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

class ImageLoader {
	private var runningRequests = [UUID: URLSessionDataTask]()
	private let cache = NSCache<NSURL, UIImage>()

	func loadImage(
		_ url: URL,
		_ completion: @escaping (Result<UIImage, Error>) -> Void
	) -> UUID? {
		if let image = self.cache.object(forKey: url as NSURL) {
			completion(.success(image))
			return nil
		}
		
		let uuid = UUID()
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			defer { self.runningRequests.removeValue(forKey: uuid) }
			
			if let data = data, let image = UIImage(data: data) {
				self.cache.setObject(image, forKey: url as NSURL)
				completion(.success(image))
				return
			}
			
			guard let error = error else {
				return
			}
			
			guard (error as NSError).code == NSURLErrorCancelled else {
				completion(.failure(error))
				return
			}
			
			// the request was cancelled, no need to call the callback
		}
		task.resume()
		
		self.runningRequests[uuid] = task
		return uuid
	}
	
	func cancelLoad(_ uuid: UUID) {
		self.runningRequests[uuid]?.cancel()
		self.runningRequests.removeValue(forKey: uuid)
	}
}

class UIImageLoader {
	static let shared = UIImageLoader()
	private let imageLoader = ImageLoader()
	private var uuidMap = [UIImageView: UUID]()
	
	private init() {}
	
	func load(_ url: URL, for imageView: UIImageView) {
		let token = self.imageLoader.loadImage(url) { result in
			
			defer { self.uuidMap.removeValue(forKey: imageView) }
			
			switch result {
			case .success(let image):
				DispatchQueue.main.async {
					imageView.image = image
				}
			case .failure(let error):
				print(error)
			}
		}
		
		if let token = token {
			self.uuidMap[imageView] = token
		}
	}
	
	func cancel(for imageView: UIImageView) {
		if let uuid = uuidMap[imageView] {
			self.imageLoader.cancelLoad(uuid)
			self.uuidMap.removeValue(forKey: imageView)
		}
	}
}

extension UIImageView {
	func loadImage(at url: URL) {
		UIImageLoader.shared.load(url, for: self)
	}
	
	func cancelImageLoad() {
		UIImageLoader.shared.cancel(for: self)
	}
}
