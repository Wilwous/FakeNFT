//
//  UsersNFTsMockData.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

import UIKit

struct UsersNFTsMockData {
    static let nfts: [(
        image: UIImage?,
        title: String,
        rating: UIImage?,
        author: String,
        priceValue: String
    )] = [
        (
            image: UIImage(named: "card_april"),
            title: "Название",
            rating: UIImage(named: "rating_0"),
            author: "Автор",
            priceValue: "0 ETH"
        )
    ]
}

