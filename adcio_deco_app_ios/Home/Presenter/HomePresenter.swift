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
    
    func onClick(_ suggestion: SuggestionEntity) {
        guard suggestion.product.isAd else { return }
        
        let option = LogOptionMapper.map(from: suggestion.option)
        
        analyticsManager.onClick(option: option, customerID: nil) { result in
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
            excludingProductIDs: ["1001"],
            categoryID: "1",
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male, 
            filters:
                Filter(provinceID: ProvinceID(equalTo: "1"))
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
            filters:
                Filter(provinceID: ProvinceID(equalTo: "1"))
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
