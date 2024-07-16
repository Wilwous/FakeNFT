//
//  Typealias.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import Foundation

// MARK: - Typealiases

typealias Binding<T> = (T) -> Void
typealias NftCollectionCompletion = (Result<[NftCollection], Error>) -> Void
typealias NftResultCompletion = (Result<NftResultModel, Error>) -> Void
typealias CartResultCompletion = (Result<CartResponseModel, Error>) -> Void
typealias ProfileInfoResultCompletion = (Result<UserProfileResponseModel, Error>) -> Void
typealias LikesResultCompletion = (Result<LikesResultModel, Error>) -> Void
