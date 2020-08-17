import UIKit

class MainView: UIView {
    @IBOutlet weak var trendingGifCollection: UICollectionView!
    @IBOutlet weak var trendingStickerCollection: UICollectionView!
    @IBOutlet weak var titleIImageGif: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var randomTitleLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadImageTitle: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    func configure() {
        backImage.image = UIImage.gifImageWithName("back")
        hideLabel()
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
    
    func hideLabel() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.randomTitleLabel.alpha = 0
        }
    }
    
    func showLabel() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.randomTitleLabel.alpha = 1
        }
    }
}
