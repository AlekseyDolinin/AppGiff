import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        tagLabel.textColor = .Pink_
    }

    class var reuseIdentifier: String {
        return "TagCell"
    }
    
    class var nibName: String {
        return "TagCell"
    }
    
    func setCell(textTag: String) {
        tagLabel.text = "#\(textTag)"
    }
}
