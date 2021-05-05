import UIKit
import GoogleMobileAds
import PinterestLayout

class SearchViewController: UIViewController, GADBannerViewDelegate, PinterestLayoutDelegate {
    
    var searchView: SearchView! {
        guard isViewLoaded else {return nil}
        return (view as! SearchView)
    }
    
    var bannerView: GADBannerView!
//    var arrayLinks = [String]()
    var searchText = ""
    var offset = 0
    var arrayAllGifsData = [GifImageData]()
    var totalCountSearchGif: Int!
    
    let layout = PinterestLayout()
    
    var typeContent = TypeContent.gifs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.searchText = self.searchText
        searchView.configure()
        setGadBanner()
        
        ///
        selectedTabs(typeContent.rawValue)
        
        setCollection()
    }
    
    func setCollection() {
        searchView.searchCollectionView.delegate = self
        searchView.searchCollectionView.dataSource = self
        searchView.searchInput.delegate = self
        
        searchView.searchInput.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        searchView.searchCollectionView.collectionViewLayout = layout
        layout.delegate = self
        layout.cellPadding = 6
        layout.numberOfColumns = 2
        searchView.searchCollectionView.contentInset = .init(top: 180, left: 0, bottom: 120, right: 0)
    }
    
    ///
    func selectedTabs(_ nameTab: String) {
        
        searchView.setTab(nameTab: nameTab)
        typeContent = nameTab == TypeContent.gifs.rawValue ? TypeContent.gifs : TypeContent.stickers
        
        /// поиск выбранного тэга
        if searchText != "" {
            searchRequest(offset: offset)
        }
    }
    
    ///
    func search() {
        if self.searchText != "" {
            print(self.searchText)
            arrayAllGifsData = []
            offset = 0
            totalCountSearchGif = 0
            searchView.searchCollectionView.reloadData()
            searchRequest(offset: 0)
        }
    }
    
    /// selectTab
    @IBAction func selectTab(_ sender: UIButton) {
        if let nameTab = sender.restorationIdentifier {
            
            arrayAllGifsData = []
            offset = 0
            totalCountSearchGif = 0
            searchView.searchCollectionView.reloadData()
            selectedTabs(nameTab)
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        search()
    }
    
    ///
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

