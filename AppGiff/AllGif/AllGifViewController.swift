import UIKit
import SwiftyJSON

var currentCollection = [Data]()

class AllPopularViewController: UIViewController, UIScrollViewDelegate {
    
    static let shared = AllPopularViewController()
    
    @IBOutlet weak var allPopularCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGestureBack()
        backImage.image = UIImage.gifImageWithName("back")
        if currentCollection == arrayPopularGifData {
            titleLabel.text = "Popular GIF"
        } else if currentCollection == arrayPopularStickerData {
            titleLabel.text = "Popular Stickers"
        }
        if let layout = allPopularCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        allPopularCollectionView.contentInset = UIEdgeInsets(top: 76, left: 8, bottom: 70, right: 8)
        
        loadGif()
    }
    
    func setGestureBack() {
        var swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func loadGif() {
        let metod: String = "https://"
        let endPointGif: String = "api.giphy.com/v1/gifs/trending"
        let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
        let countGif = "300"
        let rating = "G"
        let requestURLGIF = metod + endPointGif + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
        loadPopular(requestURL: requestURLGIF)
    }
    
    let task = URLSession.shared
    
    func loadPopular(requestURL: String) {
        guard let stringURL = URL(string: requestURL) else { return }
        task.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                let json = try JSON(data: data)
                let arrayUrlPopular = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
                for stringUrl in arrayUrlPopular {
                    self.loadImageData(stringUrl: stringUrl)
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadImageData(stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            currentCollection.append(data)
            DispatchQueue.main.async {
                self.allPopularCollectionView.reloadData()
            }
        }
        task.resume()
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
extension AllPopularViewController: PinterestLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = UIImage.gifImageWithData(currentCollection[indexPath.row])
        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
        let newWidthImage = self.view.frame.width / 2 - 24
        let newHeightImage = newWidthImage / ratio
        return newHeightImage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllPopularCollectionViewCell
        allCell.imageGif.image = UIImage.gifImageWithData(currentCollection[indexPath.row])
        return allCell
    }
}
