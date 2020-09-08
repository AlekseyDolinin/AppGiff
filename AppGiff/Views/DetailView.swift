import UIKit

class DetailView: UIView {
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    
    func configure() {
        backImage.image = UIImage.gifImageWithName("back")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: NSNotification.Name(rawValue: "reloadCollection"), object: nil)
    }
    
    func updateTopImage() {
        detailCollectionView.reloadData()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: { [weak self] in
            self?.detailCollectionView.contentOffset.y = 0
        })
    }
    
    @objc func reloadCollection() {
        detailCollectionView.reloadData()
    }
}
