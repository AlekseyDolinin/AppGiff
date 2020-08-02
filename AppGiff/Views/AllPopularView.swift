import UIKit

class AllPopularView: UIView {

    @IBOutlet weak var allPopularCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    
    func configure() {
        backImage.image = UIImage.gifImageWithName("back")
        setCollection()
    }
    
    func setCollection() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            let widthCell = self!.frame.size.width / 2 - 12
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 64, left: 8, bottom: 70, right: 8)
            layout.itemSize = CGSize(width: widthCell, height: widthCell / 2 * 3)
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            self?.allPopularCollectionView!.collectionViewLayout = layout
            self?.allPopularCollectionView.keyboardDismissMode = .onDrag
        }
    }
}
