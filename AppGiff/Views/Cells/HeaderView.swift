import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        sendButton.layer.cornerRadius = 25
        sendButton.clipsToBounds = true
        
        favoriteButton.layer.cornerRadius = 25
        favoriteButton.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)

    }
    
    @objc func favoriteAction() {
        // если gif уже в избранном
        if let indexGIF = arrayFavoritesURL.firstIndex(of: DetailViewController.linkCurrentImage) {
            arrayFavoritesURL.remove(at: indexGIF)
            favoriteButton.setImage(UIImage(named: "iconDontLikePink"), for: .normal)
        } else {
            // если gif нет в избранном
            favoriteButton.setImage(UIImage(named: "iconLikePink"), for: .normal)
            arrayFavoritesURL.append(DetailViewController.linkCurrentImage)
        }
        
        // reload collection
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollection"), object: nil)
        
    }
}
