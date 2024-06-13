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
        guard impressable else { return }
        
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
                "product_code": Filter(contains: "KY")
            ]
        ) { [weak self] result in
            switch result {
            case .success(let suggestions):
                self?.suggestions = SuggestionMapper.map(from: suggestions)
                self?.impressable = true
                print("createAdvertisementProducts ✅")
                
            case .failure(let error):
                print("createAdvertisementProducts ❌ : \(error)")
            }
        }
    }
    
    func createRecommendationProducts() {
        placementManager.createRecommendationProducts(
            clientID: clientID,
            excludingProductIDs: ["1001"],
            categoryID: "1",
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male,
            filters: [
                "price_excluding_tax": Filter(not: 53636),
                "product_code": Filter(contains: "KY")
            ]
        ) { [weak self] result in
            switch result {
            case .success(let suggestions):
                self?.suggestions = SuggestionMapper.map(from: suggestions)
                self?.impressable = true
                print("createAdvertisementProducts ✅")
                
            case .failure(let error):
                print("createAdvertisementProducts ❌ : \(error)")
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
}
