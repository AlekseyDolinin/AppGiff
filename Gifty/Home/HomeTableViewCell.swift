import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var headerCellTable: UILabel!
    @IBOutlet weak var homeGifCollectionView: UICollectionView!
    @IBOutlet weak var seeAllPopularGif: UIButton!
    @IBOutlet weak var seeAllPopularSticker: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCollectionViewDataSourseDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout>
        (_ dataSourceDelegate: D, forRow row: Int) {
        
        homeGifCollectionView.delegate = dataSourceDelegate
        homeGifCollectionView.dataSource = dataSourceDelegate
        homeGifCollectionView.reloadData()
    }
}
