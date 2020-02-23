import UIKit

var arrayPopularGifData = [Data]()
var arrayPopularStickerData = [Data]()

class StartViewController: UIViewController {
    
    static let shared = StartViewController()
    
    @IBOutlet weak var versionLabel: UILabel!
    let metod: String = "https://"
    let endPointGif: String = "api.giphy.com/v1/gifs/trending"
    let endPointStickers: String = "api.giphy.com/v1/stickers/trending"
    let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
    let countGif = "15"
    let rating = "G"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURLGIF = metod + endPointGif + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
        let requestURLStickers = metod + endPointStickers + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
        API.shared.loadTrendingGif(requestURL: requestURLGIF)
        API.shared.loadTrendingSticker(requestURL: requestURLStickers)
    }
    
    override func viewDidAppear(_ animated: Bool) {

        NotificationCenter.default.addObserver(self, selector: #selector(loadContent(notification:)), name: NSNotification.Name(rawValue: "Load"), object: nil)
    }

    @objc func loadContent(notification: NSNotification) {
        print("go to MainViewController")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        vc?.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc!, animated: false, completion: nil)
        }
    }
}
