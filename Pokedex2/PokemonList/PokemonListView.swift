//
//  PokemonListView.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit
import Combine

class PokemonListView: UIView {
	
	// MARK: - Private properties
	private var pokemonsCollectionView: UICollectionView!
	private var pokemonsCollectionViewFlowLayout: UICollectionViewFlowLayout!
	
	private var pokemonListCollectionViewInsetsForSection: UIEdgeInsets {
		return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
	}
	
	private let minimumInteritemSpacingForSection: CGFloat = 16
	private let minimumLineSpacingForSection: CGFloat = 16
	
	private let pokeBallLoader = PokeBallLoader()
	private let pokemonsCollectionViewFooterReusableIdentifier = "PokemonsCollectionViewFooterReusableIdentifier"
	
	private var viewModel: PokemonListViewModel
	private var subscriptions = Set<AnyCancellable>()
	private var pokemons: [PokemonReference] = [] {
		didSet {
			self.pokemonsCollectionView.reloadData()
		}
	}
	
	private var isDownloading = false {
		didSet {
			if isDownloading {
				self.pokeBallLoader.show()
			} else {
				self.pokeBallLoader.dismiss()
			}
		}
	}

	// MARK: - Interactions
	var willDisplayCellAtRow: ((Int) -> ())?
	var didSelectPokemonAtRow: ((Int) -> ())?

	init(viewModel: PokemonListViewModel) {
		self.viewModel = viewModel

		super.init(frame: .zero)
				
		self.setup()
		self.style()
		self.layout()
		self.setupBinding()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		self.pokemonsCollectionViewFlowLayout = UICollectionViewFlowLayout()
		self.pokemonsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.pokemonsCollectionViewFlowLayout)
		
		self.pokemonsCollectionView.dataSource = self
		self.pokemonsCollectionView.delegate = self
		
		self.pokemonsCollectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reusableIdentifier)
		self.pokemonsCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.pokemonsCollectionViewFooterReusableIdentifier)
		
		self.addSubview(self.pokemonsCollectionView)
	}
	
	private func style() {
		self.pokemonsCollectionView.backgroundColor = .white
	}
	
	private func setupBinding() {
		self.viewModel.$pokemons
			.receive(on: DispatchQueue.main)
			.assign(to: \.pokemons, on: self)
			.store(in: &subscriptions)
		
		self.viewModel.$isDownloading
			.receive(on: DispatchQueue.main)
			.assign(to: \.isDownloading, on: self)
			.store(in: &subscriptions)
	}
	
	private func layout() {
		self.pokemonsCollectionView.translatesAutoresizingMaskIntoConstraints = false

		let pokemonsCollectionViewConstraints = [
			self.pokemonsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.pokemonsCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
			self.pokemonsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.pokemonsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		]
		
		NSLayoutConstraint.activate(pokemonsCollectionViewConstraints)
	}

}

// MARK: - UICollectionViewDataSource
extension PokemonListView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.pokemons.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reusableIdentifier, for: indexPath) as! PokemonCell
		
		cell.viewModel = PokemonCellViewModel(pokemonReference: self.pokemons[indexPath.row])
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

		switch kind {
		case UICollectionView.elementKindSectionFooter:
			let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.pokemonsCollectionViewFooterReusableIdentifier, for: indexPath)

			footerView.addSubview(self.pokeBallLoader)
						
			self.pokeBallLoader.translatesAutoresizingMaskIntoConstraints = false
			
			let constraints = [
				self.pokeBallLoader.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
				self.pokeBallLoader.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
				self.pokeBallLoader.widthAnchor.constraint(equalToConstant: 50),
				self.pokeBallLoader.heightAnchor.constraint(equalToConstant: 50)
			]
			NSLayoutConstraint.activate(constraints)
			
			return footerView
		default:
			return UICollectionReusableView()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize(width: self.pokemonsCollectionView.bounds.width, height: 60)
	}
}

// MARK: - UICollectionViewDelegate
extension PokemonListView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		self.willDisplayCellAtRow?(indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.didSelectPokemonAtRow?(indexPath.row)
	}
}


// MARK: - UICollectionViewDelegateFlowLayout
extension PokemonListView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let leftInset = self.pokemonListCollectionViewInsetsForSection.left
		let rightInset = self.pokemonListCollectionViewInsetsForSection.right
		
		let totInsets = leftInset + rightInset + self.minimumInteritemSpacingForSection
		
		let widthPerItem = (self.pokemonsCollectionView.bounds.width - totInsets) / 2

		return CGSize(width: widthPerItem, height: widthPerItem * 3/4)
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						insetForSectionAt section: Int) -> UIEdgeInsets {
		
		return self.pokemonListCollectionViewInsetsForSection
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		
		return self.minimumLineSpacingForSection
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		
		return self.minimumInteritemSpacingForSection
	}
}

