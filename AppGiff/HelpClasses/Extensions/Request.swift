import Alamofire

/// распечатывает информацию по запросам Alamofire
extension Request {
    public func debugLog() -> Self {
        #if DEBUG
//        debugPrint("=======================================")
//        debugPrint(self)
//        debugPrint("=======================================")
        #endif
        return self
    }
}

/// распечатывает все сетевые запросы Alamofire
extension DataRequest {
    public func LogRequest() -> Self {
        
        #if DEBUG
        Swift.print(self)
        #endif
        
        return self
    }
}
