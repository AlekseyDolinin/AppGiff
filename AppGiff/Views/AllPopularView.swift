import UIKit

class AllPopularView: UIView {

    @IBOutlet weak var allPopularCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    func configure(_ titleString: String) {
        backImage.image = UIImage.gifImageWithName("back")
        setCollection()
        titleLabel.text = "Popular \(titleString)"
        allPopularCollectionView.alpha = 0
    }
    
    func setCollection() {
        
        let widthCell = self.frame.size.width / 2 - 12
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 74, left: 8, bottom: 70, right: 8)
        layout.itemSize = CGSize(width: widthCell, height: widthCell / 2 * 3)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        allPopularCollectionView!.collectionViewLayout = layout
        allPopularCollectionView.keyboardDismissMode = .onDrag
    }
    
    func showCollection() {
        loadIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.allPopularCollectionView.alpha = 1
        }
    }
}
