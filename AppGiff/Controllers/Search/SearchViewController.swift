import UIKit
import GoogleMobileAds

struct TypeSearch {
    /// value = gifs
    static let searchGifs = "gifs"
    /// value = stickers
    static let searchStickers = "stickers"
}

class SearchViewController: UIViewController, GADBannerViewDelegate, UIGestureRecognizerDelegate {
    
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
            requestSearch(searchText: searchText, typeSearch: TypeSearch.searchGifs)
        }
        setGadBanner()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func requestSearch(searchText: String, typeSearch: String) {
        searchView.hideCollectionForSearch()
        Api.shared.search(searchText: searchText, type: typeSearch) { [weak self] (arrayLinks) in
            self?.arrayLinks = arrayLinks
            self?.searchView.setAfterRequest(arrayLinks.count)
        }
    }
    
    // MARK: - selectTab
    @IBAction func selectTab(_ sender: UIButton) {
        searchView.searchCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        searchView.setTab(nameTab: sender.restorationIdentifier!)
        typeSearch = sender.restorationIdentifier!
        
        print("searh text: \(searchView.searchBar.text!)")
        print("searh text: \(searchText)")
        
        // если инпут не пустой
        if !trimingText(inputText: searchText).isEmpty {
            requestSearch(searchText: searchText, typeSearch: typeSearch)
            searchView.searchBar.text = searchText
        } else {
            // если инпут пустой
            arrayLinks = []
            searchView.searchCollectionView.alpha = 0
        }
    }
    
    func trimingText(inputText: String) -> String {
        return inputText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

