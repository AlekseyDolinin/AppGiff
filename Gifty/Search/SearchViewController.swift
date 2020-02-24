import UIKit
import SwiftyJSON

var inputSearchText = ""
var arraySearchData = [Data]()

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    static let shared = DetailViewController()
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    
    fileprivate let headerID = "headerID"
    
    var typeContentSearch = "Gif"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGestureBack()
        backImage.image = UIImage.gifImageWithName("back")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadContentSearch(notification:)), name: NSNotification.Name(rawValue: "Load"), object: nil)
    }
    
    func setGestureBack() {
        var swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func selectTab(_ sender: UIButton) {
        arraySearchData = []
        if sender.restorationIdentifier! == "Gif" {
            typeContentSearch = "Gif"
        } else if sender.restorationIdentifier! == "Sticker"{
            typeContentSearch = "Sticker"
        }
        searchCollectionView.reloadData()
    }
    
    @objc func loadContentSearch(notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            self?.searchCollectionView.reloadData()
        }
        
        
//        print("go to MainViewController")
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
//        vc?.modalPresentationStyle = .fullScreen
//        DispatchQueue.main.async {
//            self.present(vc!, animated: false, completion: nil)
//        }
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

//MARK: Flow layout delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = UIImage.gifImageWithData(arraySearchData[indexPath.row])
        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
        let newWidthImage = self.view.frame.width / 2 - 24
        let newHeightImage = newWidthImage / ratio
        return newHeightImage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("arraySearchData.count: \(arraySearchData.count)")
        return arraySearchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        searchCell.imageGif.image = UIImage.gifImageWithData(arraySearchData[indexPath.row])
        return searchCell
    }
    
    // HeaderView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerViewCell", for: indexPath) as? HeaderSearchView else {
                fatalError("Invalid view type")
        }
        if typeContentSearch == "Gif" {
            headerView.tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15)
            headerView.tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.07)
        } else if typeContentSearch == "Sticker" {
            headerView.tabButtonGif.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.07)
            headerView.tabButtonSticker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1494553257)
        }
        headerView.tabButtonGif.addTarget(self, action: #selector(selectTab), for: .touchUpInside)
        headerView.tabButtonSticker.addTarget(self, action: #selector(selectTab), for: .touchUpInside)
        DispatchQueue.main.async {
            headerView.searchBar.becomeFirstResponder()
        }
        return headerView
    }
    
    // Height Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColums: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 8
        let cellSpacing: CGFloat = 4
        let image = UIImage.gifImageWithData(arraySearchData[indexPath.row])
        let height: CGFloat = (image?.size.height)!
        let widthColum = (width / numberOfColums) - (xInsets + cellSpacing)
        let resultSize: CGSize = CGSize(width: widthColum, height: widthColum * 2 / 3)
        
        return resultSize
    }
    // Did Select Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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
        
        arraySearchData = []
        
        let metod: String = "https://"
        let endPointSearchGif: String = "api.giphy.com/v1/gifs/search?"
        let endPointSearchStickers: String = "api.giphy.com/v1/stickers/search?"
        let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
        let countGif = "50"
        let rating = "G"
        let language = "en"
        
        let requestURLGIF = metod + endPointSearchGif + "api_key=" + apiKey + "&q=" + inputSearchText + "&limit=" + countGif + "&offset=0&rating=" + rating + "&lang=" + language
        let requestURLSticker = metod + endPointSearchStickers + "api_key=" + apiKey + "&q=" + inputSearchText + "&limit=" + countGif + "&offset=0&rating=" + rating + "&lang=" + language
        
        if typeContentSearch == "Gif" {
            ApiSearch.shared.searchData(requestURL: requestURLGIF)
        } else if typeContentSearch == "Sticker" {
            ApiSearch.shared.searchData(requestURL: requestURLSticker)
        }
    }
}

extension SearchViewController {
    
//    func searchData(requestURL: String) {
//        guard let stringURL = URL(string: requestURL) else { return }
//        let task = URLSession.shared.dataTask(with: stringURL) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error ?? "error")
//                return
//            }
//            do {
//                let json = try JSON(data: data)
//                let arrayUrlSearchGif = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
//
//                self.arraySearchData = []
//
//                for stringUrl in arrayUrlSearchGif {
//                    self.loadImageData(stringUrl: stringUrl)
//                }
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//
//    func loadImageData(stringUrl: String) {
//        guard let url = URL(string: stringUrl) else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data, error == nil else {
//                print(error ?? "error")
//                return
//            }
//            self.arraySearchData.append(data)
//
//            if self.arraySearchData.count == 50  {
//                DispatchQueue.main.async { [weak self] in
//                    self?.searchCollectionView.reloadData()
//                }
////                task.finishTasksAndInvalidate()
////                NotificationCenter.default.post(name: NSNotification.Name("Load"), object: true)
//            }
//        }
//        task.resume()
//    }
}
