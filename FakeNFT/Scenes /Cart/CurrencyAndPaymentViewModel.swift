//
//  CurrencyAndPaymentViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Combine
import Foundation

final class CurrencyAndPaymentViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currencies: [Currency] = []
    @Published var isLoading: Bool = false
    @Published var selectedCurrency: Currency?
    
    // MARK: - Private Properties
    
    private let unifiedService: NftServiceCombine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subjects
    
    let paymentSuccessSubject = PassthroughSubject<Void, Never>()
    let paymentFailedSubject = PassthroughSubject<Void, Never>()
    let clearCartSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    
    init(unifiedService: NftServiceCombine) {
        self.unifiedService = unifiedService
        loadCurrencies()
    }
    
    // MARK: - Public Methods
    
    func payOrder(with currency: Currency) {
        isLoading = true
//        paymentFailedSubject.send() // временно для тестирования алерта
        unifiedService.payOrder(with: currency)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure:
                    self?.paymentFailedSubject.send()
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                if response.success {
                    self?.paymentSuccessSubject.send()
                    self?.clearCart(orderId: response.orderId)
                    self?.clearCartSubject.send()
                } else {
                    self?.paymentFailedSubject.send()
                }
            })
            .store(in: &cancellables)
    }
    // MARK: - Private Methods
    
    private func loadCurrencies() {
        isLoading = true
        unifiedService.loadCurrencies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("Failed to load currencies: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] currencies in
                self?.currencies = currencies
            })
            .store(in: &cancellables)
    }
    
    private func clearCart(orderId: String) {
        let orderId = "1"
        let emptyNftIds: [String] = []
        unifiedService.updateOrder(id: orderId, nftIds: emptyNftIds)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to clear cart: \(error.localizedDescription)")
                case .finished:
                    print("Cart cleared successfully")
                }
            }, receiveValue: { order in
                print("Order updated: \(order)")
            })
            .store(in: &cancellables)
    }
}
