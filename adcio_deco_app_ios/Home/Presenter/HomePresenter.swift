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
    func onClick(_ suggestion: SuggestionEntity)
    func onImpression(with option: LogOptionEntity)
    func createAdvertisementProducts()
}

final class HomePresenter {
    private let clientID: String = "542b343f-f103-44ff-93a2-174722e0b5f7"
    private var analyticsManager: AnalyticsViewManageable
    private var placementManager: PlacementManageable
    //Impression should only run once after the screen is launched.  This logic prevents Impression from being called multiple times.
    private var impressionManager: ImpressionManageable
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
        self.impressionManager = ImpressionManager()
        self.view = view
    }
    
    func onClick(_ suggestion: SuggestionEntity) {
        guard suggestion.product.isAd else { return }
        
        let option = LogOptionMapper.map(from: suggestion.option)
        
        analyticsManager.onClick(option: option,
                                 customerID: nil,
                                 productIDOnStore: suggestion.product.id) { result in
            switch result {
            case .success(let isSuccess):
                print("onClick ✅ \(isSuccess) ")
            case .failure(let error):
                print("onClick ❌ : \(error) ")
            }
        }
    }
    
    func onImpression(with option: LogOptionEntity) {
        guard !impressable(with: option.adsetID) else {
            return
        }
        
        append(with: option.adsetID)
        
        let optionEntity = LogOptionMapper.map(from: option)
        
        analyticsManager.onImpression(option: optionEntity,
                                      customerID: nil,
                                      productIDOnStore: nil) { result in
            switch result {
            case .success(let isSuccess):
                print("onImpression ✅ \(isSuccess) ")
            case .failure(let error):
                print("onImpression ❌ : \(error) ")
            }
        }
    }
    
    func createAdvertisementProducts() {
        placementManager.createAdvertisementProducts(
            clientID: clientID,
            excludingProductIDs: nil,
            categoryID: "2179",
            placementID: "5ae9907f-3cc2-4ed4-aaa4-4b20ac97f9f4",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male,
            filters: [
                "price_excluding_tax": Filter(not: 53636),
                "product_code": Filter(contains: "KY"),
                "province_id": Filter(equalTo: 1)
            ]
        ) { [weak self] result in
            switch result {
            case .success(let suggestions):
                self?.suggestions = SuggestionMapper.map(from: suggestions)
                print("createAdvertisementProducts ✅")
                
            case .failure(let error):
                print("createAdvertisementProducts ❌ : \(error)")
            }
        }
    }
    
    func createRecommendationProducts() {
        placementManager.createRecommendationProducts(
            clientID: clientID,
            excludingProductIDs: nil,
            categoryID: nil,
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male,
            filters: nil
        ) { [weak self] result in
            switch result {
            case .success(let result):
                self?.suggestions = SuggestionMapper.map(from: result)
                
                print("createRecommendationProducts ✅")
                print("isBaseline : \(result.metadata?.isBaseline)")
                self?.suggestions.forEach { suggestion in
                    print(suggestion.option.adsetID)
                }
                
            case .failure(let error):
                print("createRecommendationProducts ❌ : \(error.localizedDescription)")
            }
        }
    }
    
    func createAdvertisementBanners() {
        placementManager.createAdvertisementBanners(
            clientID: clientID,
            excludingProductIDs: ["1031"],
            categoryID: "1",
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male) { [weak self] result in
                switch result {
                case .success(let suggestions):
                    // success do something
                    print("createAdvertisementProducts ✅")
                    
                case .failure(let error):
                    // failure do something
                    print("createAdvertisementProducts ❌ : \(error)")
                }
            }
    }
    
    func createRecommendationBanners() {
        placementManager.createRecommendationBanners(
            clientID: clientID,
            excludingProductIDs: ["1031"],
            categoryID: "1",
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male) { [weak self] result in
                switch result {
                case .success(let suggestions):
                    // success do something
                    print("createAdvertisementProducts ✅")
                    
                case .failure(let error):
                    // failure do something
                    print("createAdvertisementProducts ❌ : \(error)")
                }
            }
    }
    
    private func impressable(with adSetID: AdSetID) -> Bool {
        return impressionManager.impressable(with: adSetID)
    }
    
    private func append(with adSetID: AdSetID) {
        impressionManager.append(with: adSetID)
    }
}
