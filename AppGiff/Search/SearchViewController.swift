import UIKit
import GoogleMobileAds

struct TypeSearch {
    /// value = gifs
    static let searchGifs = "gifs"
    /// value = stickers
    static let searchStickers = "stickers"
}

class SearchViewController: UIViewController, GADBannerViewDelegate {
    
    var searchView: SearchView! {
        guard isViewLoaded else {return nil}
        return (view as! SearchView)
    }
    
    var dataTransition = [String: Any]()

    var arrayLinks = [String]()
    var bannerView: GADBannerView!
    var typeSearch = String()
    var searchText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dataTransition["tagString"] != nil {
            searchText = dataTransition["tagString"] as! String
        }
        
        if dataTransition["typeSearch"] != nil {
            typeSearch = dataTransition["typeSearch"] as! String
        }
        
        searchView.configure(typeSearch: typeSearch, searchText: searchText)
        
        if typeSearch == TypeSearch.searchGifs && searchText != "" {
            request(searchText: searchText, typeSearch: TypeSearch.searchGifs)
        }
        
        setGadBanner()
        setGestureBack()
    }
    
    // MARK: - setGestureBack
    func setGestureBack() {
        var swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func request(searchText: String, typeSearch: String) {
        searchView.hideCollectionForSearch()
        Api.shared.search(searchText: searchText, count: "80", type: typeSearch) { [weak self] (arrayLinks) in
            
            self?.arrayLinks = arrayLinks
            self?.searchView.setAfterRequest()
        }
    }
    
    // MARK: - selectTab
    @IBAction func selectTab(_ sender: UIButton) {
        searchView.searchCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        searchView.setTab(nameTab: sender.restorationIdentifier!)
        typeSearch = sender.restorationIdentifier!
        if !trimingText(inputText: searchText).isEmpty {
            request(searchText: searchText, typeSearch: typeSearch)
        }
    }
    
    func trimingText(inputText: String) -> String {
        return inputText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        back()
    }
}

