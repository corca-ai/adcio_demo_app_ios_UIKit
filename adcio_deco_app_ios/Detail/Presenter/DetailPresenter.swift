//
//  DetailPresenter.swift
//  adcio_deco_app_ios
//
//  Created by 김민식 on 4/24/24.
//

import Foundation
import AdcioAnalytics

protocol DetailPresenterView: AnyObject {
    func onView(with path: String)
    func onAddToCart()
    func onPurchase()
}

final class DetailPresenter {
    private let clientID: String = "f8f2e298-c168-4412-b82d-98fc5b4a114a"
    private var analyticsManager: AnalyticsProductManageable
    private(set) var suggestion: SuggestionEntity
    
    weak var view: DetailPresenterView?
    
    init(suggestion: SuggestionEntity, view: DetailPresenterView) {
        self.analyticsManager = AnalyticsManager(clientID: clientID)
        self.suggestion = suggestion
        self.view = view
    }
    
    func thumbnailImage() -> String {
        return suggestion.product.image
    }
    
    func seller() -> String {
        return suggestion.product.seller
    }
    
    func name() -> String {
        return suggestion.product.name
    }
    
    func price() -> Int {
        return suggestion.product.price
    }
    
    func identifier() -> String {
        return suggestion.product.id
    }
    
    func onView(with path: String) {
        analyticsManager.onView(customerID: nil,
                                productIDOnStore: suggestion.product.id,
                                title: suggestion.product.name,
                                requestID: suggestion.option.requestId,
                                adsetID: suggestion.option.adsetId,
                                categoryIDOnStore: nil) { result in
            switch result {
            case .success(let isSuccess):
                print("\(path) viewChanged \(isSuccess) ✅")
                
            case .failure(let error):
                print("\(path) viewChanged : \(error) ❌")
            }
        }
    }
    
    func onAddToCart() {
        analyticsManager.onAddToCart(cartID: nil,
                                     customerID: nil,
                                     productIDOnStore: nil,
                                     reqeustID: nil,
                                     adsetID: nil,
                                     categoryIdOnStore: nil,
                                     quantity: nil) { result in
            switch result {
            case .success(let isSuccess):
                print("addToCart \(isSuccess) ✅")
            case .failure(let error):
                print("addToCart : \(error) ❌")
            }
        }
    }
    
    func onPurchase() {
        analyticsManager.onPurchase(orderID: "orderID",
                                    customerID: nil,
                                    requestID: suggestion.option.requestId,
                                    adsetID: suggestion.option.adsetId,
                                    categoryIDOnStore: nil,
                                    quantity: nil,
                                    productIDOnStore: suggestion.product.id,
                                    amount: suggestion.product.price) { result in
            switch result {
            case .success(let isSuccess):
                print("productPurchased \(isSuccess) ✅")
            case .failure(let error):
                print("productPurchased : \(error) ❌")
            }
        }
    }
}
