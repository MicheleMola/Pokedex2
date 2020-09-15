//
//  PokemonListView.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit

struct PokemonListViewModel {
	let pokemons: [Pokemon]
}

class PokemonListView: UIView {
	// MARK: - Public properties
	var viewModel: PokemonListViewModel? {
		didSet {
			self.update()
		}
	}
	
	var isDownloading = false {
		didSet {
			if isDownloading {
				self.pokeBallLoader.show()
			} else {
				self.pokeBallLoader.dismiss()
			}
		}
	}
	
	// MARK: - Private properties
	private var pokemonsCollectionView: UICollectionView!
	private var pokemonsCollectionViewFlowLayout: UICollectionViewFlowLayout!
	
	private var pokemonListCollectionViewInsetsForSection: UIEdgeInsets {
		return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
	}
	
	private static let minimumInteritemSpacingForSection: CGFloat = 16
	private static let minimumLineSpacingForSection: CGFloat = 16
	private static let cellHeight: CGFloat = 120
	
	private let pokeBallLoader = PokeBallLoader()
	private let pokemonsCollectionViewFooterReusableIdentifier = "PokemonsCollectionViewFooterReusableIdentifier"

	// MARK: - Interactions
	var willDisplayCellAtRow: ((Int) -> ())?
	var didSelectPokemonAtRow: ((Int) -> ())?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func update() {
		self.pokemonsCollectionView.reloadData()
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
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.layout()
	}
}

// MARK: - UICollectionViewDataSource
extension PokemonListView: UICollectionViewDataSource {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		return viewModel?.pokemons.count ?? 0
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reusableIdentifier, for: indexPath) as! PokemonCell
		
		if let pokemon = viewModel?.pokemons[indexPath.row] {
			cell.viewModel = PokemonCellViewModel(pokemon: pokemon)
		}
		
		return cell
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
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
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		return CGSize(width: self.pokemonsCollectionView.bounds.width, height: 60)
	}
}

// MARK: - UICollectionViewDelegate
extension PokemonListView: UICollectionViewDelegate {
	func collectionView(
		_ collectionView: UICollectionView,
		willDisplay cell: UICollectionViewCell,
		forItemAt indexPath: IndexPath
	) {
		self.willDisplayCellAtRow?(indexPath.row)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		didSelectItemAt indexPath: IndexPath
	) {
		self.didSelectPokemonAtRow?(indexPath.row)
	}
}


// MARK: - UICollectionViewDelegateFlowLayout
extension PokemonListView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let leftInset = self.pokemonListCollectionViewInsetsForSection.left
		let rightInset = self.pokemonListCollectionViewInsetsForSection.right
		
		let totalInsets = leftInset + rightInset
		let widthPerItem: CGFloat = self.pokemonsCollectionView.bounds.width - totalInsets
	
		return CGSize(width: widthPerItem, height: Self.cellHeight)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		self.pokemonListCollectionViewInsetsForSection
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		Self.minimumLineSpacingForSection
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumInteritemSpacingForSectionAt section: Int
	) -> CGFloat {
		Self.minimumInteritemSpacingForSection
	}
}

