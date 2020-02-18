import UIKit
import SwiftyJSON

extension StartViewController {
    
    func loadTrendingGif(requestURL: String) {
        
        guard let stringURL = URL(string: requestURL) else { return }
        let task = URLSession.shared.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                let json = try JSON(data: data)
                let arrayUrlTraidingGif = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
                for stringUrl in arrayUrlTraidingGif {
                    self.loadGif(stringUrl: stringUrl)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func loadGif(stringUrl: String) {
        let url = URL(string: stringUrl)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            let imageGifData = data
            arrayTrandingGifData.append(imageGifData)
            if arrayTrandingGifData.count == 50 {
                self.nextVC()
            }
        }
        task.resume()
    }
}
