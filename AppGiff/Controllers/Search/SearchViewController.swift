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
    var searchText: String!
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
        
        /// поиск выбранного тэга
        if searchText != nil {
            searchRequest(offset: 0)
        }
        
        ///
        selectedTabs(typeContent.rawValue)
        
        setCollection()
    }
    
    func setCollection() {
        searchView.searchCollectionView.delegate = self
        searchView.searchCollectionView.dataSource = self
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
        
        arrayAllGifsData = []
        offset = 0
        totalCountSearchGif = 0
        
        searchRequest(offset: offset)
        
        
        
//        /// если инпут не пустой
//        if searchText != nil && searchText != "" {
//            requestSearch(searchText: searchText, typeSearch: typeSearch)
//            searchView.searchBar.text = searchText
//        } else {
//            // если инпут пустой
//            arrayLinks = []
//            searchView.searchCollectionView.alpha = 0
//        }
    }
    
    /// selectTab
    @IBAction func selectTab(_ sender: UIButton) {
        if let nameTab = sender.restorationIdentifier {
            selectedTabs(nameTab)
            //        searchView.searchCollectionView.setContentOffset(CGPoint(x: 0, y: -180), animated: true)
            //        searchView.searchCollectionView.scrollRectToVisible(CGRect.zero, animated: true)
//            searchView.searchCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    ///
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

