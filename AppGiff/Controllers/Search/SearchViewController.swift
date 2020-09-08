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
    
    var tag:  String?
    var arrayLinks = [String]()
    var bannerView: GADBannerView!
    var typeSearch = String()
    var searchText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tag != nil {
            searchText = tag!
        } else {
            selectedTabs("gifs")
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
    
    func selectedTabs(_ nameTab: String) {
        
        searchView.searchCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        searchView.setTab(nameTab: nameTab)
        typeSearch = nameTab
        
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
    
    // MARK: - selectTab
    @IBAction func selectTab(_ sender: UIButton) {
        if let nameTab = sender.restorationIdentifier {
            selectedTabs(nameTab)
        }
    }
    
    func trimingText(inputText: String) -> String {
        return inputText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

