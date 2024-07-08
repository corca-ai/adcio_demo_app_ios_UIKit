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
    func createRecommendationProducts(userAgent: String?)
    func createAdvertisementBanners()
    func createRecommendationBanners()
}

final class HomePresenter {
    private let clientID: String = "7bbb703e-a30b-4a4a-91b4-c0a7d2303415"
    private var analyticsManager: AnalyticsViewManageable
    private var placementManager: PlacementManageable
    //Impression should only run once after the screen is launched.  This logic prevents Impression from being called multiple times.
    private var impressionManager: ImpressionManageable
    private(set) var suggestions: [SuggestionEntity] = [] {
        didSet {
            self.reloadCollectionView?()
        }
    }
    private var excludingProductIDs: [String] = ["458007", "1211423", "1165080", "182602"]
    private var baselineProductIDs = [String]()
    
    
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
            excludingProductIDs: excludingProductIDs,
            categoryID: nil,
            placementID: "e4e14a3c-d99f-4646-b31e-bbe144e65dff",
            customerID: nil,
            fromAgent: false,
            baselineProductIDs: baselineProductIDs,
            filters: nil,
            targets: nil,
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
            
            let suggestions = SuggestionMapper.map(from: result)
            self?.suggestions.append(contentsOf: suggestions.map { $0 })
            self?.excludingProductIDs.append(contentsOf: self?.suggestions.compactMap { $0.product.idOnStore } ?? [])
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
            excludingProductIDs: excludingProductIDs,
            categoryID: nil,
            placementID: "e97f9b4b-91ac-4835-a1f7-3098b9868f69",
            customerID: nil,
            fromAgent: false,
            baselineProductIDs: baselineProductIDs,
            filters: nil,
            targets: nil,
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
            
            let suggestions = SuggestionMapper.map(from: result)
            self?.suggestions.append(contentsOf: suggestions.map { $0 })
            self?.excludingProductIDs.append(contentsOf: self?.suggestions.compactMap { $0.product.idOnStore } ?? [])
            print("createRecommendationProducts ✅")
            suggestions.forEach { entity in
                print("isBaseline", entity.isBaseline)
                print("requestID : \(entity.option.requestID)")
                print("idOnStore : \(entity.product.idOnStore)")
            }
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
