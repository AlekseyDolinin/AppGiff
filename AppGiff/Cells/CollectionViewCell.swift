import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageForGIF: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageForGIF.layer.cornerRadius = 5
        imageForGIF.clipsToBounds = true
    }
}
