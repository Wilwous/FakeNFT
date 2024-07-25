//
//  UsersNTFsTableView.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

import UIKit

final class UsersNTFsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Delegate
    
    weak var likeDelegate: UsersNFTsTableViewCellDelegate?
    
    //MARK: - Public Properties
    
    var nfts: [Nft] = []
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero, style: .plain)
        register(UsersNFTsTableViewCell.self, forCellReuseIdentifier: UsersNFTsTableViewCell.identifier)
        dataSource = self
        delegate = self
        rowHeight = 140
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        allowsSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UsersNFTsTableViewCell.identifier,
            for: indexPath
        ) as? UsersNFTsTableViewCell else {
            return UITableViewCell()
        }
        
        tableView.backgroundColor = .ypWhiteDay
        cell.backgroundColor = .ypWhiteDay
        let nft = nfts[indexPath.row]
        cell.configure(with: nft)
        cell.delegate = likeDelegate
        return cell
    }
}
