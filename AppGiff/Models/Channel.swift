import UIKit

class Channel {
    
    var id: String
    var type: String
    var linkImage: String
    var dataImage: Data
    
    init(id: String,
         type: String,
         linkImage: String,
         dataImage: Data)
    {
        self.id = id
        self.type = type
        self.linkImage = linkImage
        self.dataImage = dataImage
    }
}
