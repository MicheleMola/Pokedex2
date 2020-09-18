//
//  PokemonListView.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit

enum LoaderState: Int {
	case show
	case hide
	case hideWithError
}

struct PokemonListViewModel {
	let pokemons: [Pokemon]
	let loaderState: LoaderState
}

class PokemonListView: UIView {
	// MARK: - Public properties
	var viewModel: PokemonListViewModel? {
		didSet {
			self.update()
		}
	}
	
	private var oldViewModel: PokemonListViewModel?
	
	// MARK: - Private properties
	private var pokemonsCollectionView: UICollectionView!
	private var pokemonsCollectionViewFlowLayout: UICollectionViewFlowLayout!
	
	private var pokemonListCollectionViewInsetsForSection: UIEdgeInsets {
		return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
	}
	
	private static let minimumInteritemSpacingForSection: CGFloat = 16
	private static let minimumLineSpacingForSection: CGFloat = 16
	private static let cellHeight: CGFloat = 120
	
	private var footerView = PokemonsCollectionViewFooter()

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
	
	private func setup() {
		self.pokemonsCollectionViewFlowLayout = UICollectionViewFlowLayout()
		self.pokemonsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.pokemonsCollectionViewFlowLayout)
		
		self.pokemonsCollectionView.dataSource = self
		self.pokemonsCollectionView.delegate = self
		
		self.pokemonsCollectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reusableIdentifier)
		self.pokemonsCollectionView.register(
			PokemonsCollectionViewFooter.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: PokemonsCollectionViewFooter.reusableIdentifier
		)
		
		self.addSubview(self.pokemonsCollectionView)
	}
	
	private func style() {
		self.pokemonsCollectionView.backgroundColor = .white
	}
	
	private func update() {
		guard let viewModel = self.viewModel else { return }
		
		defer {
			self.oldViewModel = viewModel
		}
		
		if self.oldViewModel?.pokemons != viewModel.pokemons {
			self.pokemonsCollectionView.reloadData()
		}
		
		if self.oldViewModel?.loaderState != viewModel.loaderState {
			switch viewModel.loaderState {
			case .show: self.footerView.showLoader()
			case .hide: self.footerView.hideLoader()
			case .hideWithError: self.footerView.hideLoaderWithError()
			}
		}
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
		self.viewModel?.pokemons.count ?? 0
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
			self.footerView = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: PokemonsCollectionViewFooter.reusableIdentifier,
				for: indexPath
			) as! PokemonsCollectionViewFooter

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
		CGSize(width: self.pokemonsCollectionView.bounds.width, height: 60)
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
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
}

