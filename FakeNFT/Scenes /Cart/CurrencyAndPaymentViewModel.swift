//
//  CurrencyAndPaymentViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Combine
import Foundation

final class CurrencyAndPaymentViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var isLoading: Bool = false
    @Published var selectedCurrency: Currency?
    
    private let unifiedService: NftServiceCombine
    private var cancellables = Set<AnyCancellable>()
    
    init(unifiedService: NftServiceCombine) {
        self.unifiedService = unifiedService
        loadCurrencies()
    }
    
    // MARK: - Data Loading
    
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
}
