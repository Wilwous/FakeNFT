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
            title: "Lilo and Stitch",
            rating: UIImage(named: "rating_3"),
            author: "Шельма Стронк",
            priceValue: "1,78 ETH"
        ),
        (
            image: UIImage(named: "card_greena"),
            title: "Greena",
            rating: UIImage(named: "rating_3"),
            author: "Аспик Ди",
            priceValue: "1,78 ETH"
        ),
        (
            image: UIImage(named: "card_luna"),
            title: "Luna",
            rating: UIImage(named: "rating_3"),
            author: "Якуб Джевич",
            priceValue: "1,78 ETH"
        )
    ]
}

