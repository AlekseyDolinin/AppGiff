import UIKit

class FavoriteView: UIView {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    func configure(_ titleString: String) {
        backImage.image = UIImage.gifImageWithName("back")
        
        if titleString != "Favorite" {
            titleLabel.text = "Trending \(titleString)"
        } else {
            titleLabel.text = "Favorite"
        }
        
        collection.alpha = 0
        setCollection()
    }
    
    func setCollection() {
        let widthCell = frame.size.width / 2 - 12
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 80, left: 8, bottom: 70, right: 8)
        layout.itemSize = CGSize(width: widthCell, height: widthCell / 2 * 3)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collection!.collectionViewLayout = layout
        collection.keyboardDismissMode = .onDrag
    }
    
    func showCollection() {
        loadIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.collection.alpha = 1
        }
    }
}
