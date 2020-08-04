import UIKit
import SwiftyJSON
import GoogleMobileAds

class SearchViewController: UIViewController, GADBannerViewDelegate {
    
    static let shared = SearchViewController()
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var viewForTabBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabButtonGif: UIButton!
    @IBOutlet weak var tabButtonSticker: UIButton!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchLabel: UILabel!
    
    var bannerView: GADBannerView!
    
    var typeSearch = ""
    var searchText = ""
    var arraySearchData = [Data]()
    
    var arrayLinks = [String]()
    
    var imageCachData = NSCache<NSString, NSData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        request(searchText: searchText, typeSearch: "gifs")
        
        setGadBanner()
        setTabBar()
        setGestureBack()
        setCollection()
        setSearchBar()
        backImage.image = UIImage.gifImageWithName("back")
        searchBar.text = searchText
        setRefreshControl()
    }
    
    func request(searchText: String, typeSearch: String) {
        ApiRandom.shared.search(searchText: searchText, count: "100") { (arrayLinks) in
            self.arrayLinks = arrayLinks
            self.searchCollectionView.reloadData()
        }
    }
    
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        searchCollectionView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        searchCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func setSearchBar() {
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(named: "White_")
        textFieldInsideSearchBar?.font = UIFont(name: "SFProDisplay-Light", size: 20.0)
        textFieldInsideSearchBar?.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.4)
        textFieldInsideSearchBar?.textAlignment = .center
        searchBar.barTintColor = .clear
    }
    
    func setTabBar() {
        tabButtonGif.layer.cornerRadius = 20
        tabButtonGif.clipsToBounds = true
        tabButtonSticker.layer.cornerRadius = 20
        tabButtonSticker.clipsToBounds = true
    }
    
    func setCollection() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            let widthCell = self!.view.frame.size.width / 2 - 12
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 136, left: 8, bottom: 70, right: 8)
            layout.itemSize = CGSize(width: widthCell, height: widthCell / 2 * 3)
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            self?.searchCollectionView!.collectionViewLayout = layout
            self?.searchCollectionView.keyboardDismissMode = .onDrag
        }
    }
    
    func setGestureBack() {
        var swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func selectTab(_ sender: UIButton) {
        if sender.restorationIdentifier! == "gifs" {
            typeSearch = "gifs"
            tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15)
            tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
            
            request(searchText: searchText, typeSearch: "gifs")
            
        } else if sender.restorationIdentifier! == "stickers" {
            typeSearch = "stickers"
            tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
            tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15)
            
            request(searchText: searchText, typeSearch: "stickers")
        }
        
//        let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//        if !searchText!.isEmpty {
//            searchBar.resignFirstResponder()
//
//            if typeSearch == "gifs" {
//                request(searchText: searchText!, typeSearch: "gifs")
//            } else {
//                request(searchText: searchText!, typeSearch: "stickers")
//            }
        
//        } else {
//            searchBar.becomeFirstResponder()
//        }
    }
    
    @objc func loadContentSearch(notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            self?.searchCollectionView.isUserInteractionEnabled = true
            self?.searchCollectionView.alpha = 1.0
            self?.loadIndicator.stopAnimating()
            self?.searchLabel.isHidden = true
            self?.searchCollectionView.reloadData()
        }
    }
    
    @objc func back() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
//        inputSearchText = ""
        arraySearchData = [Data]()
        back()
    }
}

//MARK: -  delegates
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        
        if let data = imageCachData.object(forKey: arrayLinks[indexPath.row] as NSString) {
            searchCell.imageGif.image = UIImage.gifImageWithData(data as Data)
            searchCell.loadIndicator.stopAnimating()
        } else {
            ApiRandom.shared.loadData(urlString: arrayLinks[indexPath.row]) { (data) in
                self.imageCachData.setObject(data as NSData, forKey: self.arrayLinks[indexPath.row] as NSString)
                searchCell.imageGif.image = UIImage.gifImageWithData(data)
                searchCell.loadIndicator.startAnimating()
                self.searchCollectionView.reloadData()
            }
        }
        loadIndicator.stopAnimating()
        searchLabel.isHidden = true
        return searchCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = (searchCollectionView.frame.width - 24) / 2
        return CGSize(width: value, height: value)
    }
    
    // Did Select Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.currentIndex = indexPath.row
        vc.nameCurrentCollection = collectionView.restorationIdentifier!
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchCollectionView.isUserInteractionEnabled = false
//        searchCollectionView.alpha = 0.1
//        loadIndicator.startAnimating()
//        searchLabel.isHidden = false
        searchRequest(searchText: searchBar.text!)
    }
    
    func searchRequest(searchText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.searchCollectionView.reloadData()
            self?.searchBar.resignFirstResponder()
            
        }
        
        
        
//        let metod: String = "https://"
//        let type = "gifs"
//        let endPointSearchStickers: String = "api.giphy.com/v1/stickers/search?"
//        let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
//        let countGif = "50"
        
//        let requestURLGIF = metod + "api.giphy.com/v1/\(type)/search?" + "api_key=\(apiKey)" + "&q=" + searchText + "&limit=" + countGif + "&offset=0&rating=G&lang=en"
//
//        let requestURLSticker = metod + endPointSearchStickers + "api_key=\(apiKey)" + "&q=" + searchText + "&limit=" + countGif + "&offset=0&rating=G&lang=en"
        
//        if typeContentSearch == "Gif" {
//            ApiSearch.shared.searchData(requestURL: requestURLGIF)
//        } else if typeContentSearch == "Sticker" {
//            ApiSearch.shared.searchData(requestURL: requestURLSticker)
//        }
    }
}
