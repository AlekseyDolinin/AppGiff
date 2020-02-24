import UIKit

class HeaderSearchView: UICollectionReusableView {
    
    @IBOutlet weak var viewForTabBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tabButtonGif: UIButton!
    @IBOutlet weak var tabButtonSticker: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        tabButtonGif.layer.cornerRadius = 20
        tabButtonSticker.layer.cornerRadius = 20

    }
    
}
