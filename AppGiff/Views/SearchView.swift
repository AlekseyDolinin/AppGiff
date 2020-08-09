import UIKit

class SearchView: UIView {
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var viewForTabBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabButtonGif: UIButton!
    @IBOutlet weak var tabButtonSticker: UIButton!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchLabel: UILabel!
    
    var arraySearchData = [Data]()
    
    
    func configure(typeSearch: String, searchText: String) {
        
        backImage.image = UIImage.gifImageWithName("back")
        searchBar.text = searchText
        
        if typeSearch == TypeSearch.searchGifs {
            hideCollectionForSearch()
            hideAnimateSearch()
            searchBar.becomeFirstResponder()
        }
        
        setTabBar()
        setCollection()
        setSearchBar()
        setRefreshControl()
    }
    
    func setAfterRequest() {
        searchCollectionView.isUserInteractionEnabled = true
        searchCollectionView.alpha = 1
        hideAnimateSearch()
        searchCollectionView.reloadData()
    }
    
    // MARK: - setTabBar
    func setTabBar() {
        tabButtonGif.layer.cornerRadius = 20
        tabButtonGif.clipsToBounds = true
        tabButtonSticker.layer.cornerRadius = 20
        tabButtonSticker.clipsToBounds = true
    }
    
    // MARK: - setCollection
    func setCollection() {
        searchCollectionView.alpha = 0
        let widthCell = frame.size.width / 2 - 12
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 150, left: 8, bottom: 70, right: 8)
        layout.itemSize = CGSize(width: widthCell, height: widthCell / 2 * 3)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        searchCollectionView!.collectionViewLayout = layout
        searchCollectionView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - setSearchBar
    func setSearchBar() {
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(named: "White_")
        textFieldInsideSearchBar?.font = UIFont(name: "SFProDisplay-Light", size: 20.0)
        textFieldInsideSearchBar?.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.4)
        textFieldInsideSearchBar?.textAlignment = .center
        searchBar.barTintColor = .clear
    }
    
    // MARK: - refresh collection
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        searchCollectionView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        searchCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func setTab(nameTab: String) {
        searchCollectionView.scrollRectToVisible(CGRect.zero, animated: true)
        if nameTab == "gifs" {
            tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15)
            tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
        } else if nameTab == "stickers" {
            tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
            tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15)
        }
    }
    
    func hideCollectionForSearch() {
        showAnimateSearch()
        searchCollectionView.alpha = 0
        searchCollectionView.isUserInteractionEnabled = false
        searchBar.resignFirstResponder()
        searchCollectionView.reloadData()
    }
    
    func hideAnimateSearch() {
        loadIndicator.stopAnimating()
        searchLabel.isHidden = true
    }
    
    func showAnimateSearch() {
        loadIndicator.startAnimating()
        searchLabel.isHidden = false
    }
    
    
}
