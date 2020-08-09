import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        sendButton.layer.cornerRadius = 25
        sendButton.clipsToBounds = true
    }
}
