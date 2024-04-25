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
    func viewChanged(with path: String)
    func productTapped(_ suggestion: SuggestionEntity)
    func productImpressed(with option: LogOptionEntity)
    func createSuggestion()
}

final class HomePresenter {
    private let clientID: String = "76dc12fa-5a73-4c90-bea5-d6578f9bc606"
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
    
    func viewChanged(with path: String) {
        analyticsManager.viewChanged(path: path) { result in
            switch result {
            case .success(let isSuccess):
                print("\(path) viewChanged \(isSuccess) ✅")
            case .failure(let error):
                print("\(path) viewChanged : \(error) ❌")
            }
        }
    }
    
    func productTapped(_ suggestion: SuggestionEntity) {
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
            excludingProductIDs: ["1321"],
            categoryID: "2017",
            placementID: "5ae9907f-3cc2-4ed4-aaa4-4b20ac97f9f4",
            customerID: "corca0302",
            placementPositionX: 80,
            placementPositionY: 80,
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
