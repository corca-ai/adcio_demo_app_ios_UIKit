//
//  HomePresenter.swift
//  adcio_deco_app_ios
//
//  Created by 10004 on 4/24/24.
//

import Foundation

import AdcioAnalytics
import AdcioPlacement
import ControllerV1

protocol HomePresenterView: AnyObject {
    func onClick(_ suggestion: SuggestionEntity)
    func onImpression(with option: LogOptionEntity)
    func createAdvertisementProducts(userAgent: String?)
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
                                 productIDOnStore: suggestion.product.id, 
                                 userAgent: nil) { result, error in
            guard error == nil else {
                print("onClick ❌ : \(error)")
                return
            }
            
            guard let result else {
                print("onClick ❌")
                return
            }
            
            print("onClick ✅")
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
                                      productIDOnStore: nil, 
                                      userAgent: nil) { result, error in
            guard error == nil else {
                print("onImpression ❌ : \(error)")
                return
            }
            
            guard let result else {
                print("onImpression ❌")
                return
            }
            
            print("onImpression ✅")
        }
    }
    
    /// create Advertisement Products method
    func createAdvertisementProducts(userAgent: String? = nil) {
        placementManager.createAdvertisementProducts(
            clientID: clientID,
            excludingProductIDs: nil,
            categoryID: nil,
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: nil,
            fromAgent: false,
            baselineProductIDs: nil,
            filters: nil,
            targets: [
                SuggestionRequestTarget(keyName: "", values: [])
            ],
            userAgent: userAgent)
        { [weak self] result, error in
            guard error == nil else {
                print("createAdvertisementProducts ❌ : \(error)")
                return
            }
            
            guard let result else {
                print("products is nil ❌")
                return
            }
            
            self?.suggestions = SuggestionMapper.map(from: result)
            print("createAdvertisementProducts ✅")
        }
    }
    
    /// create Advertisement Banners method
    func createAdvertisementBanners() {
        placementManager.createAdvertisementBanners(
            clientID: clientID,
            excludingProductIDs: nil,
            categoryID: nil,
            placementID: "placementID",
            customerID: "customerID",
            fromAgent: false,
            targets: [], 
            userAgent: nil)
        { [weak self] result, error in
            guard error == nil else {
                print("createAdvertisementBanners ❌ : \(error)")
                return
            }
            
            guard let result else {
                print("banner is nil ❌")
                return
            }
            
            //success
            print("createAdvertisementBanners ✅")
        }
    }
    
    /// create Recommendation Products method
    func createRecommendationProducts(userAgent: String? = nil) {
        placementManager.createRecommendationProducts(
            clientID: clientID,
            excludingProductIDs: nil,
            categoryID: nil,
            placementID: "01019bab-ab09-4d0b-af9c-18b0e52d472c",
            customerID: nil,
            fromAgent: false,
            baselineProductIDs: nil,
            filters: [
                [
                    "price_excluding_tax": ProductFilterOperationDto(not: 53636),
                    "product_code": ProductFilterOperationDto(contains: "KY")
                ]
            ],
            targets: [
                SuggestionRequestTarget(keyName: "", values: [])
            ],
            userAgent: nil)
        { [weak self] result, error in
            guard error == nil else {
                print("createRecommendationProducts ❌ : \(error)")
                return
            }
            
            guard let result else {
                print("products is nil ❌")
                return
            }
            
            self?.suggestions = SuggestionMapper.map(from: result)
            print("createRecommendationProducts ✅")
        }
    }
    
    /// create Recommendation Bannders method
    func createRecommendationBanners() {
        placementManager.createRecommendationBanners(
            clientID: clientID,
            excludingProductIDs: nil,
            categoryID: nil,
            placementID: "placementID",
            customerID: "customerID",
            fromAgent: false,
            targets: [],
            userAgent: nil)
        { [weak self] result, error in
            guard error == nil else {
                print("createRecommendationBanners ❌ : \(error)")
                return
            }
            
            guard let result else {
                print("banner is nil ❌")
                return
            }
            
            //success
            print("createRecommendationBanners ✅")
        }
    }
    
    private func impressable(with adSetID: AdSetID) -> Bool {
        return impressionManager.impressable(with: adSetID)
    }
    
    private func append(with adSetID: AdSetID) {
        impressionManager.append(with: adSetID)
    }
}
