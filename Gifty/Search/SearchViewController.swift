import UIKit
import SwiftyJSON

var inputSearchText = ""
var arraySearchData = [Data]()

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    static let shared = SearchViewController()
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var viewForTabBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tabButtonGif: UIButton!
    @IBOutlet weak var tabButtonSticker: UIButton!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    var typeContentSearch = "Gif"
    var typeSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIndicator.stopAnimating()
        
        setTabBar()
        setGestureBack()
        setLayoutGrid()
        backImage.image = UIImage.gifImageWithName("back")
        
        if typeSearch == "tag" {
            loadIndicator.startAnimating()
            searchBar.resignFirstResponder()
        } else {
            loadIndicator.stopAnimating()
            searchBar.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.text = inputSearchText
        NotificationCenter.default.addObserver(self, selector: #selector(loadContentSearch(notification:)), name: NSNotification.Name(rawValue: "Load"), object: nil)
    }
    
    func setTabBar() {
        tabButtonGif.layer.cornerRadius = 20
        tabButtonGif.clipsToBounds = true
        tabButtonSticker.layer.cornerRadius = 20
        tabButtonSticker.clipsToBounds = true
    }
    
    func setLayoutGrid() {
        if let layout = searchCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        searchCollectionView.contentInset = UIEdgeInsets(top: 136, left: 8, bottom: 70, right: 8)
    }
    
    func setGestureBack() {
        var swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func selectTab(_ sender: UIButton) {
//        arraySearchData = []
        if sender.restorationIdentifier! == "Gif" {
            typeContentSearch = "Gif"
            tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15)
            tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.07)
        } else if sender.restorationIdentifier! == "Sticker"{
            typeContentSearch = "Sticker"
            tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.07)
            tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1494553257)
        }
        searchBar.text = ""
        searchBar.becomeFirstResponder()
    }
    
    @objc func loadContentSearch(notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            self?.loadIndicator.stopAnimating()
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
        inputSearchText = ""
        arraySearchData = [Data]()
        back()
    }
}

//MARK: Flow layout delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = UIImage.gifImageWithData(arraySearchData[indexPath.row])
        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
        let newWidthImage = self.view.frame.width / 2 - 24
        let newHeightImage = newWidthImage / ratio
        return newHeightImage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !arraySearchData.isEmpty {
            return arraySearchData.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        if !arraySearchData.isEmpty {
            searchCell.imageGif.image = UIImage.gifImageWithData(arraySearchData[indexPath.row])
            return searchCell
        }
        return UICollectionViewCell()
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

extension SearchViewController {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        searchBar.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputSearchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadIndicator.startAnimating()
        searchRequest(searchText: inputSearchText)
    }
    
    func searchRequest(searchText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.searchCollectionView.reloadData()
            self?.searchBar.resignFirstResponder()
            
        }
        let metod: String = "https://"
        let endPointSearchGif: String = "api.giphy.com/v1/gifs/search?"
        let endPointSearchStickers: String = "api.giphy.com/v1/stickers/search?"
        let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
        let countGif = "50"
        let rating = "G"
        let language = "en"
        
        let requestURLGIF = metod + endPointSearchGif + "api_key=" + apiKey + "&q=" + searchText + "&limit=" + countGif + "&offset=0&rating=" + rating + "&lang=" + language
        let requestURLSticker = metod + endPointSearchStickers + "api_key=" + apiKey + "&q=" + searchText + "&limit=" + countGif + "&offset=0&rating=" + rating + "&lang=" + language
        
        if typeContentSearch == "Gif" {
            ApiSearch.shared.searchData(requestURL: requestURLGIF)
        } else if typeContentSearch == "Sticker" {
            ApiSearch.shared.searchData(requestURL: requestURLSticker)
        }
    }
}
