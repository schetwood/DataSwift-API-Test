import Foundation

class Request<ModelType: Decodable> {
    var targetPath: String {
        return ""
    }
    
    var queryItems: [String: String] {
        return [:]
    }
    
    var successHandler: (ModelType) -> Void {
        return { _ in }
    }
    var failureHandler: (Error?) -> Void {
        return { _ in }
    }
}
