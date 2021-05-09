import UIKit

class TrendingCell: UICollectionViewCell {
    
    @IBOutlet weak var imageForGIF: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageForGIF.layer.cornerRadius = 5
        imageForGIF.clipsToBounds = true
    }
    
    func setCell(link: String) {
        if Array(Storage.storage.keys).contains(link) {
            imageForGIF.image = UIImage.gifImageWithData(Storage.storage[link]!)
        } else {
            Api.shared.loadData(urlString: link) { (dataImage) in
                let image: UIImage = UIImage.gifImageWithData(dataImage)!
                self.imageForGIF.image = image
                Storage.storage[link] = dataImage
            }
        }
    }
}
