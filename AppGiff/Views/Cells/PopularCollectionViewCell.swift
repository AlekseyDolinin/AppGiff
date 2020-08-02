import UIKit

class PopularGifCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageForGIF: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageForGIF.layer.cornerRadius = 5
        imageForGIF.clipsToBounds = true
    }
}

class PopularStickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageForSticker: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageForSticker.layer.cornerRadius = 5
        imageForSticker.clipsToBounds = true
    }

}
