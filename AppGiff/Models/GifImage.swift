import UIKit

class GifImageData {
    
    var id: String
    var dataImage: Data
    var linkImage: String
    
    init(id: String,
         dataImage: Data,
         linkImage: String) {
        
        self.id = id
        self.dataImage = dataImage
        self.linkImage = linkImage
    }
}

enum TypeContent: String {
    case gifs = "gifs"
    case stickers = "stickers"
}
