import UIKit
import SwiftyJSON

class API {

    static let shared = API()
    
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
                    self.loadImageData(stringUrl: stringUrl, typeContent: "Gif")
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func loadTrendingSticker(requestURL: String) {
        
        guard let stringURL = URL(string: requestURL) else { return }
        let task = URLSession.shared.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                let json = try JSON(data: data)
                let arrayUrlTraidingSticker = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
                for stringUrl in arrayUrlTraidingSticker {
                    self.loadImageData(stringUrl: stringUrl, typeContent: "Sticker")
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func loadImageData(stringUrl: String, typeContent: String) {
        let url = URL(string: stringUrl)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            if typeContent == "Sticker" {
                arrayTrandingStickerData.append(data)
//                print(data)
            } else {
                arrayTrandingGifData.append(data)
            }
            
//            print("arrayTrandingGifData: \(arrayTrandingGifData.count)")
//            print("arrayTrandingStickerData: \(arrayTrandingStickerData.count)")
            
            if arrayTrandingGifData.count == 25 && arrayTrandingStickerData.count == 25 {
                NotificationCenter.default.post(name: NSNotification.Name("Load"), object: true)
            }
        }
        task.resume()
    }
}
