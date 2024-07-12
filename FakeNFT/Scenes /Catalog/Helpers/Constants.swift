//
//  Constants.swift
//  FakeNFT
//
//  Created by Антон Павлов on 03.07.2024.
//

import Foundation

//MARK: - Constants

struct Constants {
    
    //MARK: - CatalogViewController
    
    static let filterAlertTitle = "Сортировка"
    static let filetNameButtonTitle = "По названию"
    static let filterQuantityButtonTitle = "По количеству NFT"
    static let closeAlertButtonTitle = "Отменить"
    
    //MARK: - CatalogSorterStorage
    
    static let filterKey = "catalogFilter"
    
    //MARK: - TestCatalogController
    
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
    static let testNftId = "22"
    
    //MARK: - CollectionViewController
    
    static let leftRightInsets: Double = 16
    static let spaceBetweenCoverAndInfo: Double = 8
    static let infoHeight: Double = 56
    static let minimumInteritemSpacing: Double = 9
    static let minimumLineSpacing: Double = 28
}
