//
//  DetailPresenter.swift
//  adcio_deco_app_ios
//
//  Created by 김민식 on 4/24/24.
//

import Foundation
import AdcioAnalytics

protocol DetailPresenterView: AnyObject {
    func viewChanged(with path: String)
    func addToCart()
    func productPurchased()
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
    
    func viewChanged(with path: String) {
        analyticsManager.viewChanged(path: path, 
                                     customerID: "corca0302",
                                     productIDOnStore: suggestion.product.id,
                                     title: suggestion.product.name) { result in
            switch result {
            case .success(let isSuccess):
                print("\(path) viewChanged \(isSuccess) ✅")
            
            case .failure(let error):
                print("\(path) viewChanged : \(error) ❌")
            }
        }
    }
    
    func addToCart() {
        analyticsManager.addToCart(cartID: "cartID",
                                   productIDOnStore: suggestion.product.id) { result in
            switch result {
            case .success(let isSuccess):
                print("addToCart \(isSuccess) ✅")
            case .failure(let error):
                print("addToCart : \(error) ❌")
            }
        }
    }
    
    func productPurchased() {
        analyticsManager.productPurchased(orderID: "orderID",
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
