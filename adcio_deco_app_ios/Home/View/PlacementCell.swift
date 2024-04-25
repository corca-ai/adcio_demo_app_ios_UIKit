//
//  PlacementCell.swift
//  adcio_deco_app_ios
//
//  Created by 10004 on 4/24/24.
//

import UIKit

class PlacementCell: UICollectionViewCell {
    
    static let cellName = "PlacementCell"
    static let cellReuseIdentifier = "PlacementCell"

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ suggestion: SuggestionEntity) {
        nameLabel.text = suggestion.product.name
        priceLabel.text = "\(suggestion.product.price)₩"
        sellerLabel.text = suggestion.product.seller
        
        thumbnailImage.backgroundColor = .lightGray
        
        guard let url = URL(string: suggestion.product.image) else { return }
        
        ImageLoader.loadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.thumbnailImage.image = image
            }
        }
    }
}
