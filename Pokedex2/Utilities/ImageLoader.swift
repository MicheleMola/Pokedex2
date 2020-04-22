//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Michele Mola on 03/04/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

let cache = NSCache<NSURL, UIImage>()

class ImageLoader {
	private var runningRequests = [UUID: URLSessionDataTask]()
	
	func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
		
		if let image = cache.object(forKey: url as NSURL) {
			completion(.success(image))
			return nil
		}
		
		let uuid = UUID()
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in

			defer { self.runningRequests.removeValue(forKey: uuid) }
			
			if let data = data, let image = UIImage(data: data) {
				cache.setObject(image, forKey: url as NSURL)
				completion(.success(image))
				return
			}
			
			guard let error = error else {
				// without an image or an error, we'll just ignore this for now
				// you could add your own special error cases for this scenario
				return
			}
			
			guard (error as NSError).code == NSURLErrorCancelled else {
				completion(.failure(error))
				return
			}
			
			// the request was cancelled, no need to call the callback
		}
		task.resume()
		
		runningRequests[uuid] = task
		return uuid
	}
	
	func cancelLoad(_ uuid: UUID) {
		runningRequests[uuid]?.cancel()
		runningRequests.removeValue(forKey: uuid)
	}
}


class UIImageLoader {
	static let loader = UIImageLoader()
	
	private let imageLoader = ImageLoader()
	private var uuidMap = [UIImageView: UUID]()
	
	private init() {}
	
	func load(_ url: URL, for imageView: UIImageView) {
		let token = imageLoader.loadImage(url) { result in
	
			defer { self.uuidMap.removeValue(forKey: imageView) }
			
			do {
				let image = try result.get()
				DispatchQueue.main.async {
					imageView.image = image
				}
			} catch {
				// handle the error
			}
		}
		
		if let token = token {
			uuidMap[imageView] = token
		}
	}
	
	func cancel(for imageView: UIImageView) {
		if let uuid = uuidMap[imageView] {
			imageLoader.cancelLoad(uuid)
			uuidMap.removeValue(forKey: imageView)
		}
	}
}

extension UIImageView {
	func loadImage(at url: URL) {
		UIImageLoader.loader.load(url, for: self)
	}
	
	func cancelImageLoad() {
		UIImageLoader.loader.cancel(for: self)
	}
}
