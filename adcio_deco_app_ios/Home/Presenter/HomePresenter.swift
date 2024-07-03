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
                                 productIDOnStore: suggestion.product.id) { result, error in
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
                                      productIDOnStore: nil) { result, error in
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
    
    func createAdvertisementProducts() {
        placementManager.createAdvertisementProducts(ProductSuggestionRequestDto(
            sessionId: placementManager.sessionID,
            deviceId: placementManager.deviceID,
            customerId: "corca0302",
            placementId: "01019bab-ab09-4d0b-af9c-18b0e52d472c",
            placementPositionX: nil,
            placementPositionY: nil,
            fromAgent: false,
            birthYear: 2000,
            gender: .male,
            clientId: clientID,
            excludingProductIds: nil,
            categoryId: nil,
            filters: nil)
        ) { [weak self] result, error in
            guard error == nil else {
                print("createAdvertisementProducts ❌ : \(error)")
                return
            }
            
            guard let result else {
                print("createAdvertisementProducts ❌")
                return
            }
            
            self?.suggestions = SuggestionMapper.map(from: result)
            print("createAdvertisementProducts ✅")
        }
    }
    
    private func impressable(with adSetID: AdSetID) -> Bool {
        return impressionManager.impressable(with: adSetID)
    }
    
    private func append(with adSetID: AdSetID) {
        impressionManager.append(with: adSetID)
    }
}
