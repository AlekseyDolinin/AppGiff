import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var favoriteButtton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        sendButton.layer.cornerRadius = 25
        sendButton.clipsToBounds = true
        
        favoriteButtton.layer.cornerRadius = 25
        favoriteButtton.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        
    }
    
    @objc func favoriteAction() {
        
        print("добавление в избранное")
        
        
    }
    
    
    
}
