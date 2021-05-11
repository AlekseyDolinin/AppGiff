import UIKit

class GifImageData {
    
    var id: String
    var dataImage: Data
    var linkGifImage: String
    var linkLoopVideo: String
    
    init(id: String,
         dataImage: Data,
         linkGifImage: String,
         linkLoopVideo: String
        ) {
        
        self.id = id
        self.dataImage = dataImage
        self.linkGifImage = linkGifImage
        self.linkLoopVideo = linkLoopVideo
    }
}

enum TypeContent: String {
    case gifs = "gifs"
    case stickers = "stickers"
}
