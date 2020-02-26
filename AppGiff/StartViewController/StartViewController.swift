import UIKit

var arrayPopularGifData = [Data]()
var arrayPopularStickerData = [Data]()

var arrayTitleGif = [String]()
var arrayTitleSticker = [String]()

var randomDataGif = Data()
var randomTitle = ""

var loadRandomGif = Bool()

class StartViewController: UIViewController {
    
    static let shared = StartViewController()
    
    @IBOutlet weak var versionLabel: UILabel!
    
    let metod: String = "https://"
    let endPointGif: String = "api.giphy.com/v1/gifs/trending"
    let endPointStickers: String = "api.giphy.com/v1/stickers/trending"
    let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
    let countGif = "50"
    let rating = "G"
    
    var titles = ["#thumbs up", "#the bachelor", "#shrug", "#yes", "#no", "#wow", "#mad", "#excited", "#bye", "#happy", "#hello", "#love"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        versionLabel.text = "Version " + String(getVersionApp()) + " " + getSystemLanguage()
        versionLabel.text = "Version " + String(getVersionApp())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRandomGif()
        getPopular()
        NotificationCenter.default.addObserver(self, selector: #selector(loadContent(notification:)), name: NSNotification.Name(rawValue: "Load"), object: nil)
    }
    
    func getPopular() {
        let requestURLGIF = metod + endPointGif + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
        let requestURLStickers = metod + endPointStickers + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
        API.shared.loadTrendingGif(requestURL: requestURLGIF)
        API.shared.loadTrendingSticker(requestURL: requestURLStickers)
    }
    
    func getRandomGif() {
        randomTitle = titles.randomElement()!
        randomTitle.removeFirst()
        let url = "https://api.giphy.com/v1/gifs/random?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&tag=" + randomTitle + "&rating=G"
        ApiRandom.shared.randomData(requestURL: url)
    }

    // получение номера версии приложения
    func getVersionApp() -> String {
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        return version
    }
    
    func getSystemLanguage() -> String {
        var systemLanguage = String()
        let preferredLanguage = NSLocale.preferredLanguages[0]
        switch preferredLanguage {
        case "ru-RU":
            systemLanguage = "Russia"
        case "en":
            systemLanguage = "England"
        case "zh-Hans":
            systemLanguage = "China"
        default:
            systemLanguage = "England"
        }
        return systemLanguage
    }
    
    @objc func loadContent(notification: NSNotification) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        vc?.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc!, animated: false, completion: nil)
        }
    }
}
