//
//  DetailViewController.swift
//  adcio_deco_app_ios
//
//  Created by 김민식 on 4/24/24.
//

import UIKit

class DetailViewController: UIViewController {
    static let identifier = "DetailViewControllerIdentifer"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var suggestion: SuggestionEntity?
    private var presenter: DetailPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let suggestion else { return }
        presenter = DetailPresenter(suggestion: suggestion, view: self)
        
        self.navigationItem.title = presenter?.name() ?? ""
        guard let url = URL(string: presenter?.thumbnailImage() ?? "") else { return }
        
        ImageLoader.loadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
            }
        }
    
        nameLabel.text = presenter?.name()
        priceLabel.text = "\(presenter?.price() ?? 0)₩"
        sellerLabel.text = presenter?.seller()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewChanged(with: "Deatil")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func configure(_ suggestion: SuggestionEntity, completion: () -> Void) {
        self.suggestion = suggestion
        completion()
    }
    
    @IBAction func purchaseButtonTapped(_ sender: UIButton) {
        productPurchased()
    }
    
    @IBAction func addCartButtonTapped(_ sender: UIBarButtonItem) {
        addToCart()
    }
}

extension DetailViewController: DetailPresenterView {
    func viewChanged(with path: String) {
        DispatchQueue.main.async {
            self.presenter?.viewChanged(with: path)
        }
    }
    
    func addToCart() {
        DispatchQueue.main.async {
            self.presenter?.addToCart()
        }
    }
    
    func productPurchased() {
        DispatchQueue.main.async {
            self.presenter?.productPurchased()
        }
    }
}
