//
//  FavoritesNFTsCollectionView.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 02.07.2024.
//

import UIKit

protocol FavoritesNFTsCollectionViewDelegate: AnyObject {
    func didUpdateItems(_ items: [NFTItem])
}

final class FavoritesNFTsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FavoritesNFTsCollectionViewCellDelegate {

    weak var itemsDelegate: FavoritesNFTsCollectionViewDelegate?

    private var items: [NFTItem]

    init(items: [NFTItem]) {
        self.items = items

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 20

        super.init(frame: .zero, collectionViewLayout: layout)

        delegate = self
        dataSource = self
        register(FavoritesNFTsCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesNFTsCollectionViewCell.identifier)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesNFTsCollectionViewCell.identifier, for: indexPath) as? FavoritesNFTsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.row])
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = 16 + 16 + 8 
        let width = (collectionView.frame.size.width - CGFloat(totalSpacing)) / 2
        return CGSize(width: width, height: 80)
    }

    func didTapLikeButton(in cell: FavoritesNFTsCollectionViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        items.remove(at: indexPath.item)
        deleteItems(at: [indexPath])
        itemsDelegate?.didUpdateItems(items)
    }

    func updateItems(_ newItems: [NFTItem]) {
        items = newItems
        reloadData()
    }

    func getItems() -> [NFTItem] {
        return items
    }
}
