import UIKit

class GifHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageGif: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGif.layer.cornerRadius = 5
        imageGif.clipsToBounds = true
    }
}
