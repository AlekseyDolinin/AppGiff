import UIKit

class MainView: UIView {
    @IBOutlet weak var trendingGifCollection: UICollectionView!
    @IBOutlet weak var trendingStickerCollection: UICollectionView!
    @IBOutlet weak var titleIImageGif: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var randomTitleLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadImageTitle: UIButton!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var stackTags: UIStackView!
    @IBOutlet weak var tagCollection: UICollectionView!
    @IBOutlet weak var removeAD: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backImage.image = UIImage.gifImageWithName("back")
        searchBackView.layer.cornerRadius = 8
        removeAD.isHidden = StoreManager.removeAD() == false ? false : true
    }
    
    func setTitleImage(randomDataGif: Data) {
        titleIImageGif.layer.cornerRadius = 5
        titleIImageGif.clipsToBounds = true
        titleIImageGif.image = UIImage.gifImageWithData(randomDataGif)
        loadIndicator.stopAnimating()
    }
    
    func clearImageGif() {
        titleIImageGif.image = nil
        loadIndicator.startAnimating()
    }
}
