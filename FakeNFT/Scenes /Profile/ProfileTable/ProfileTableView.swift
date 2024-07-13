//
//  ProfileTableView.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 22.06.2024.
//

import UIKit

final class ProfileTableView: UITableViewController {

    private let iconImage = UIImage(systemName: "chevron.forward")!
    private let unifiedService: NftServiceCombine
    var myNFTsCount = 0
    var favoritesNFTsCount = 0

    private var items: [(String, String?, UIImage)] {
        return [
            ("Мои NFT", "(\(myNFTsCount))", iconImage),
            ("Избранные NFT", "(\(favoritesNFTsCount))", iconImage),
            ("О разработчике", nil, iconImage)
        ]
    }

    init(unifiedService: NftServiceCombine) {
        self.unifiedService = unifiedService
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.rowHeight = 54
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhiteDay
    }

    private func rightToLeftTransition() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(mainText: item.0, secondaryText: item.1, icon: item.2)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            let usersNFTsVC = UsersNFTsViewController(nftService: unifiedService)
            let navController = UINavigationController(rootViewController: usersNFTsVC)
            navController.modalPresentationStyle = .fullScreen
            rightToLeftTransition()
            present(navController, animated: false, completion: nil)
        }

        if indexPath.row == 1 {
            let usersNFTsVC = FavoritesNFTsViewController(unifiedService: unifiedService)
            let navController = UINavigationController(rootViewController: usersNFTsVC)
            navController.modalPresentationStyle = .fullScreen
            rightToLeftTransition()
            present(navController, animated: false, completion: nil)
        }
    }
}
