import UIKit

class SearchView: UIView {
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var viewForTabBar: UIView!
    @IBOutlet weak var tabButtonGif: UIButton!
    @IBOutlet weak var tabButtonSticker: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchInput: UITextField!
    
    var searchText: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        UIApplication.shared.statusBarView?.backgroundColor = .Pink_
        loader.stopAnimating()
        
        tabButtonGif.layer.cornerRadius = 20
        tabButtonGif.clipsToBounds = true
        tabButtonSticker.layer.cornerRadius = 20
        tabButtonSticker.clipsToBounds = true
        
        searchBackView.layer.cornerRadius = 8
//        hideCollectionForSearch()
        setCollection()
//        setRefreshControl()
        
        searchButton.alpha = 0.75
        searchInput.attributedPlaceholder = NSAttributedString(string: "Search",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchInput.keyboardType = .asciiCapable
        searchInput.returnKeyType = .search

    }
    
    
    func configure() {
        if searchText == nil || searchText == "" {
            searchInput.becomeFirstResponder()
        } else {
            searchInput.text = searchText
        }
    }
    
//    func setAfterRequest(_ countLink: Int) {
//        // если нашлась хотя бы 1 анимация
//        if countLink != 0 {
//            searchCollectionView.isUserInteractionEnabled = true
//            hideAnimateSearch()
//            searchCollectionView.reloadData()
//
//            // если ничего не нашлось
//        } else {
//            loadIndicator.stopAnimating()
//            searchLabel.text = "NOT FOUND"
//        }
//    }
    
    
    // MARK: - setCollection
    func setCollection() {
        let widthCell = frame.size.width / 2 - 12
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 150, left: 8, bottom: 70, right: 8)
        layout.itemSize = CGSize(width: widthCell, height: widthCell / 2 * 3)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        searchCollectionView!.collectionViewLayout = layout
    }
    
//    // MARK: - refresh collection
//    func setRefreshControl() {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
//        searchCollectionView.refreshControl = refreshControl
//    }
    
//    @objc func doSomething(refreshControl: UIRefreshControl) {
//        searchCollectionView.reloadData()
//        refreshControl.endRefreshing()
//    }
    
    func setTab(nameTab: String) {
        if nameTab == TypeContent.gifs.rawValue {
            tabButtonGif.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
            tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
        } else {
            tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
            tabButtonSticker.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        }

    }
    
//    func hideCollectionForSearch() {
//        showAnimateSearch()
//        searchCollectionView.isUserInteractionEnabled = false
//        searchCollectionView.reloadData()
//    }
    
//    func hideAnimateSearch() {
//        loadIndicator.stopAnimating()
//        searchLabel.isHidden = true
//    }
    
//    func showAnimateSearch() {
//        loadIndicator.startAnimating()
//        searchLabel.isHidden = false
//    }
}
