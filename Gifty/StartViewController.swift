import UIKit

var arrayTrandingGifData = [Data]()
var arrayTrandingStickerData = [Data]()

class StartViewController: UIViewController {
    
    static let shared = StartViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let metod: String = "https://"
        let endPointGif: String = "api.giphy.com/v1/gifs/trending"
        let endPointStickers: String = "api.giphy.com/v1/stickers/trending"
        let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
        let countGif = "25"
        let rating = "G"
        let requestURLGIF = metod + endPointGif + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
        let requestURLStickers = metod + endPointStickers + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
        
//        DispatchQueue.main.async {
            API.shared.loadTrendingGif(requestURL: requestURLGIF)
            API.shared.loadTrendingSticker(requestURL: requestURLStickers)
//        }

        NotificationCenter.default.addObserver(self, selector: #selector(loadContent(notification:)), name: NSNotification.Name(rawValue: "Load"), object: nil)

    }

    @objc func loadContent(notification: NSNotification) {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
//        }

    }

  
}
