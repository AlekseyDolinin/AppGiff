import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class var reuseIdentifier: String {
        return "TagCell"
    }
    
    class var nibName: String {
        return "TagCell"
    }
    
    func configureCell(textTag: String) {
        tagLabel.text = textTag
    }

}
