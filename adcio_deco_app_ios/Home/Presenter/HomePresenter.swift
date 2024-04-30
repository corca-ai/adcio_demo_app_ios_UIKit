//
//  HomePresenter.swift
//  adcio_deco_app_ios
//
//  Created by 10004 on 4/24/24.
//

import Foundation

import AdcioAnalytics
import AdcioPlacement

protocol HomePresenterView: AnyObject {
    func productTapped(_ suggestion: SuggestionEntity)
    func productImpressed(with option: LogOptionEntity)
    func createSuggestion()
}

final class HomePresenter {
    private let clientID: String = "f8f2e298-c168-4412-b82d-98fc5b4a114a"
    private var analyticsManager: AnalyticsViewManageable
    private var placementManager: PlacementManageable
    private var impressable: Bool = false
    private(set) var suggestions: [SuggestionEntity] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    weak var view: HomePresenterView?
    var reloadCollectionView: (() -> Void)?
    
    init(view: HomePresenterView) {
        self.analyticsManager = AnalyticsManager(clientID: clientID)
        self.placementManager = PlacementManager()
        self.view = view
    }
    
    func productTapped(_ suggestion: SuggestionEntity) {
        guard suggestion.product.isAd else { return }
        
        let option = LogOptionMapper.map(from: suggestion.option)
        
        analyticsManager.productTapped(option: option) { result in
            switch result {
            case .success(let isSuccess):
                print("productTapped ✅ \(isSuccess) ")
            case .failure(let error):
                print("productTapped ❌ : \(error) ")
            }
        }
    }
    
    func productImpressed(with option: LogOptionEntity) {
        guard impressable else { return }
        
        let optionEntity = LogOptionMapper.map(from: option)
        
        analyticsManager.productImpressed(option: optionEntity) { result in
            switch result {
            case .success(let isSuccess):
                print("productImpressed ✅ \(isSuccess) ")
            case .failure(let error):
                print("productImpressed ❌ : \(error) ")
            }
        }
    }
    
    func createSuggestion() {
        placementManager.adcioCreateSuggestion(
            clientID: clientID,
            excludingProductIDs: ["1001"],
            categoryID: "1",
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male,
            area: "Vietnam") { [weak self] result in
                switch result {
                case .success(let suggestions):
                    self?.suggestions = SuggestionMapper.map(from: suggestions)
                    self?.impressable = true
                    print("createSuggestion ✅")
                    
                case .failure(let error):
                    print("createSuggestion ❌ : \(error)")
                }
            }
    }
}
