//
//  PokemonListView.swift
//  Pokedex2
//
//  Created by Michele Mola on 21/04/2020.
//

import UIKit

/// Enum indicating the loader state
/// - show: the pokemon loader is visible;
/// - hide: the pokemon loader is not visible;
/// - hideWithError: the pokemon loader is not visible and the error label is visible.
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
	private static let cellHeight: CGFloat = 120
	private static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
	
	private var pokemonsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private var footerView = PokemonsCollectionViewFooter()
	
	var viewModel: PokemonListViewModel? {
		didSet {
			self.update()
		}
	}
	private var oldViewModel: PokemonListViewModel?

	var willDisplayCellAtRow: ((Int) -> ())?
	var didSelectPokemonAtRow: ((Int) -> ())?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
	
	private func setup() {
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
	
	// MARK: - Style

	private func style() {
		self.pokemonsCollectionView.backgroundColor = .white
	}
	
	// MARK: - Update

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
	
	// MARK: - Layout

	private func layout() {
		self.pokemonsCollectionView.translatesAutoresizingMaskIntoConstraints = false
		let pokemonsCollectionViewConstraints = [
			self.pokemonsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.pokemonsCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
			self.pokemonsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.pokemonsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		]
		NSLayoutConstraint.activate(pokemonsCollectionViewConstraints)
		
		self.layoutIfNeeded()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
						
		self.updateAfterLayout()
	}
	
	private func updateAfterLayout() {
		guard let collectionViewLayout = self.pokemonsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
		
		let totalInsets = Self.sectionInset.left + Self.sectionInset.right
		let widthPerItem: CGFloat = self.pokemonsCollectionView.bounds.width - totalInsets
		
		collectionViewLayout.itemSize = CGSize(width: widthPerItem, height: Self.cellHeight)
		collectionViewLayout.sectionInset = Self.sectionInset
	}
}

// MARK: - UICollectionViewDataSource

extension PokemonListView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.viewModel?.pokemons.count ?? 0
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: PokemonCell.reusableIdentifier,
			for: indexPath) as! PokemonCell

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
		if kind == UICollectionView.elementKindSectionFooter {
			self.footerView = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: PokemonsCollectionViewFooter.reusableIdentifier,
				for: indexPath
			) as! PokemonsCollectionViewFooter
			
			return self.footerView
		}
		
		return UICollectionReusableView()
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
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		CGSize(width: self.pokemonsCollectionView.bounds.width, height: 60)
	}
}

