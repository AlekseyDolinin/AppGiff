import UIKit
import GoogleMobileAds
import PinterestLayout

class SearchViewController: UIViewController, GADBannerViewDelegate, PinterestLayoutDelegate {
    
    var searchView: SearchView! {
        guard isViewLoaded else {return nil}
        return (view as! SearchView)
    }
    
    static var arrayFavoritesLink = [String]()
    
    var searchText = ""
    var searchTextLanguage = ""
    var offset = 0
    var arrayAllGifsData = [GifImageData]()
    var arrayTags = [String]()
    var totalCountSearchGif: Int!
    let layout = PinterestLayout()
    var typeContent = TypeContent.gifs
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.searchText = self.searchText
        searchView.configure()
        setGadBanner()
        ///
        selectedTabs(typeContent.rawValue)
        setCollection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UserDefaults.standard.array(forKey: "favoritesLinks") != nil {
            /// если есть записаные линки достаём их
            SearchViewController.arrayFavoritesLink = UserDefaults.standard.array(forKey: "favoritesLinks") as! [String]
        }
        searchView.searchCollectionView.reloadData()
        searchView.tagsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setCollection() {
        searchView.searchCollectionView.delegate = self
        searchView.searchCollectionView.dataSource = self
        searchView.tagsCollectionView.delegate = self
        searchView.tagsCollectionView.dataSource = self
        
        searchView.searchInput.delegate = self
        searchView.searchInput.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        searchView.searchCollectionView.collectionViewLayout = layout
        layout.delegate = self
        layout.cellPadding = 6
        layout.numberOfColumns = 2
        searchView.searchCollectionView.contentInset = .init(top: 180, left: 0, bottom: 120, right: 0)
        registerNib()
    }
    
    ///
    func registerNib() {
        let nib = UINib(nibName: TagCell.nibName, bundle: nil)
        searchView.tagsCollectionView?.register(nib, forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        if let flowLayout = searchView.tagsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    
    ///
    func selectedTabs(_ nameTab: String) {
        searchView.setTab(nameTab: nameTab)
        typeContent = nameTab == TypeContent.gifs.rawValue ? TypeContent.gifs : TypeContent.stickers
        /// поиск выбранного тэга
        if searchText != "" {
            searchRequest(offset: offset)
            searchSuggestions()
        }
    }
    
    ///
    func search() {
        if self.searchText != "" {
            searchView.searchInput.resignFirstResponder()
            arrayAllGifsData = []
            offset = 0
            totalCountSearchGif = 0
            searchView.searchCollectionView.reloadData()
            searchRequest(offset: 0)
            searchSuggestions()
        }
    }
    
    // MARK:- работа с избранным
    @objc func favoriteAction(sender: UIButton) {
        let link = arrayAllGifsData[sender.tag].linkImage
        /// проверяем есть ли ссылка в избранном
        let index = SearchViewController.arrayFavoritesLink.firstIndex(of: link)
        if index == nil {
            /// ссылки нет в избранном
            /// добавление ссылки в избранное
            print("ссылки нет в избранном (добавление ссылки в избранное)")
            SearchViewController.arrayFavoritesLink.append(link)
        } else {
            /// ссылка есть в избранном
            /// удаление ссылки из избранного
            print("ссылка есть в избранном (удаление ссылки из избранного)")
            SearchViewController.arrayFavoritesLink.remove(at: index!)
        }
        searchView.searchCollectionView.reloadData()
        /// запись нового массива с линками
        print("запись нового массива с линками (количество: \(SearchViewController.arrayFavoritesLink.count)")
        UserDefaults.standard.set(SearchViewController.arrayFavoritesLink, forKey: "favoritesLinks")
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

