//
//  ProductEntity.swift
//  adcio_deco_app_ios
//
//  Created by 10004 on 4/23/24.
//

import Foundation

struct ProductEntity: Codable, Hashable {
    let id: String
    let idOnStore: String
    let name: String
    let image: String
    let price: Double
    let seller: String
    let isAd: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case idOnStore
        case name = "Name (KO)"
        case image = "Image URL"
        case price = "Customer Price"
        case seller = "Winery"
        case isAd = "Available"
    }
}
