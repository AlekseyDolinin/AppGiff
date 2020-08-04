import UIKit

class MainView: UIView {
    @IBOutlet weak var popularGifCollection: UICollectionView!
    @IBOutlet weak var popularStickerCollection: UICollectionView!
    @IBOutlet weak var titleIImageGif: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var randomTitleLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadImageTitle: UIButton!
    
    func configure() {
        backImage.image = UIImage.gifImageWithName("back")
    }
    
    func setTitle(title: String, randomDataGif: Data) {
        randomTitleLabel.text = title
        titleIImageGif.layer.cornerRadius = 5
        titleIImageGif.clipsToBounds = true
        titleIImageGif.image = UIImage.gifImageWithData(randomDataGif)
        loadIndicator.stopAnimating()
    }
    
    func clearTitleGif() {
        titleIImageGif.image = nil
        loadIndicator.startAnimating()
    }
    
}
