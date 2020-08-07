import UIKit
import GoogleMobileAds

struct TypeSearch {
    /// value = gifs
    static let searchGifs = "gifs"
    /// value = stickers
    static let searchStickers = "stickers"
}

class SearchViewController: UIViewController, GADBannerViewDelegate {
    
    private var searchView: SearchView! {
        guard isViewLoaded else {return nil}
        return (view as! SearchView)
    }
    
    var arrayLinks = [String]()
    
    var bannerView: GADBannerView!
    var typeSearch = String()
    var searchText = String()
    var imageCachData = NSCache<NSString, NSData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.configure(typeSearch: typeSearch, searchText: searchText)
        
        if typeSearch == "tag" {
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
        ApiRandom.shared.search(searchText: searchText, count: "80", type: typeSearch) { [weak self] (arrayLinks) in
            
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
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
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
        
        //если нашлась data в кэше
        if let dataImage = imageCachData.object(forKey: arrayLinks[indexPath.row] as NSString) {
            searchCell.imageGif.image = UIImage.gifImageWithData(dataImage as Data)
        } else {
            //если не нашлась data в кэше
            //скачиваем по ссылке
            ApiRandom.shared.loadData(urlString: arrayLinks[indexPath.row]) { [weak self] (dataImage) in
                // кэширование data
                self?.imageCachData.setObject(dataImage as NSData, forKey: (self?.arrayLinks[indexPath.row])! as NSString)
                searchCell.imageGif.image = UIImage.gifImageWithData(dataImage)
            }
        }
        searchCell.loadIndicator.stopAnimating()
        return searchCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = (searchView.searchCollectionView.frame.width - 24) / 2
        return CGSize(width: value, height: value)
    }
    
//    // Did Select Item
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
//        vc.currentIndex = indexPath.row
//        vc.nameCurrentCollection = collectionView.restorationIdentifier!
//        view.window!.layer.add(transition, forKey: kCATransition)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false, completion: nil)
//    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchView.hideCollectionForSearch()
        if searchBar.text != nil {
            searchText = searchBar.text!
            request(searchText: searchText, typeSearch: typeSearch)
        }
    }
}
