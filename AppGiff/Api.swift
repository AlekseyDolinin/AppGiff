import UIKit
import SwiftyJSON

class API {
    
    static let shared = API()
    
    let task = URLSession.shared
    
    func loadTrendingGif(requestURL: String) {
        guard let stringURL = URL(string: requestURL) else { return }
        task.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                let json = try JSON(data: data)
                let arrayUrlPopularGif = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
                arrayTitleGif = json["data"].arrayValue.map({$0["title"].string!})
                for stringUrl in arrayUrlPopularGif {
                    self.loadImageData(stringUrl: stringUrl, typeContent: "Gif")
                }
                print("load data popular gif")
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadTrendingSticker(requestURL: String) {
        guard let stringURL = URL(string: requestURL) else { return }
        task.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                let json = try JSON(data: data)
                let arrayUrlPopularSticker = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
                arrayTitleSticker = json["data"].arrayValue.map({$0["title"].string!})
                for stringUrl in arrayUrlPopularSticker {
                    self.loadImageData(stringUrl: stringUrl, typeContent: "Sticker")
                }
                print("load data popular stickers")
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadImageData(stringUrl: String, typeContent: String) {
        guard let url = URL(string: stringUrl) else { return }
        task.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            if typeContent == "Sticker" {
                arrayPopularStickerData.append(data)
            } else if typeContent == "Gif" {
                arrayPopularGifData.append(data)
            }
            if arrayPopularGifData.count == 15 && arrayPopularStickerData.count == 15 && loadRandom == true {
                self.task.finishTasksAndInvalidate()
                NotificationCenter.default.post(name: NSNotification.Name("Load"), object: true)
            }
            print("load popular gif")
            }.resume()
    }
}
