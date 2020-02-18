import UIKit

var arrayTrandingGifData = [Data]()
var arrayURL = [String]()

class StartViewController: UIViewController {
    
    static let shared = StartViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let metod: String = "https://"
        let endPoint: String = "api.giphy.com/v1/gifs/trending"
        let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
        let countGif = "50"
        let rating = "R"
        
        let requestURL = metod + endPoint + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
        
        loadTrendingGif(requestURL: requestURL)
    }
    
    func nextVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "homeVC")
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
  
}
