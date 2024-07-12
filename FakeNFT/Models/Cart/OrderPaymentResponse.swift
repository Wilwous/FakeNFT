//
//  OrderPaymentResponse.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 12/07/2024.
//

import Foundation

struct OrderPaymentResponse: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
