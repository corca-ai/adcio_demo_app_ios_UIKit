//
//  HomeViewController.swift
//  adcio_deco_app_ios
//
//  Created by 10004 on 4/23/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var presenter: HomePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = HomePresenter(view: self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        registerXib()
        
        presenter?.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        presenter?.createAdvertisementProducts()
    }
        
    private func registerXib() {
        let nibName = UINib(nibName: PlacementCell.cellName,
                            bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: PlacementCell.cellReuseIdentifier)
    }
    
    private func checkVisibleCells() {
        for cell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: cell) {
                let cellFrame = collectionView.layoutAttributesForItem(at: indexPath)?.frame
                let visibleRect = CGRect(
                    x: collectionView.contentOffset.x,
                    y: collectionView.contentOffset.y,
                    width: collectionView.bounds.size.width,
                    height: collectionView.bounds.size.height
                )
                
                guard let suggestion = presenter?.suggestions[indexPath.item] else { return }
                
                if let cellFrame = cellFrame, visibleRect.intersects(cellFrame) {
                    let intersection = visibleRect.intersection(cellFrame)
                    let visibleArea = intersection.width * intersection.height
                    let cellArea = cellFrame.width * cellFrame.height
                    
                    if visibleArea / cellArea >= 0.5 {
                        onImpression(with: suggestion.option)
                    }
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.suggestions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: PlacementCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlacementCell.cellReuseIdentifier,
                                                                           for: indexPath) as? PlacementCell else { return UICollectionViewCell() }
        
        guard let suggestion = presenter?.suggestions[indexPath.item] else { return UICollectionViewCell() }
        cell.configure(suggestion)
        checkVisibleCells()
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let suggestion = presenter?.suggestions[indexPath.item] else { return }
        onClick(suggestion)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        detailViewController.configure(suggestion) { [weak self] in
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkVisibleCells()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 240)
    }
}

extension HomeViewController: HomePresenterView {
    func onImpression(with option: LogOptionEntity) {
        presenter?.onImpression(with: option)
    }
    
    func onClick(_ suggestion: SuggestionEntity) {
        presenter?.onClick(suggestion)
    }
    
    func createAdvertisementProducts() {
        presenter?.createAdvertisementProducts()
    }
}
