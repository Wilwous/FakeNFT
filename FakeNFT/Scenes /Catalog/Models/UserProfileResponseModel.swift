//
//  ProfileInfoResultModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 12.07.2024.
//

import Foundation

struct UserProfileResponseModel: Decodable {
    let website: String
    let likes: [String]
}
