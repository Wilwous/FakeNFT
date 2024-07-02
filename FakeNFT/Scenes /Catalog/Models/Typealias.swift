//
//  Typealias.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import Foundation

// MARK: - Typealiases

typealias NftCollectionCompletion = (Result<[NftCollection], Error>) -> Void
typealias Binding<T> = (T) -> Void
