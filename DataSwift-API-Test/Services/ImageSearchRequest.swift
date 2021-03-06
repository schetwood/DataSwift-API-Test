import Foundation

class ImageSearchRequest: Request<ImageSearchResponse> {
    private let searchQuery: String
    private let responseHandler: (ImageSearchResponse) -> Void
    private let errorHandler: (Error?) -> Void
    
    override var targetPath: String {
        return "search"
    }
    
    override var queryItems: [String : String] {
        return ["q": searchQuery]
    }
    
    override var successHandler: (ImageSearchResponse) -> Void {
        return responseHandler
    }
    
    override var failureHandler: (Error?) -> Void {
        return errorHandler
    }
    
    init(query: String,
         responseHandler: @escaping (ImageSearchResponse) -> Void,
         errorHandler: @escaping (Error?) -> Void) {
        self.searchQuery = query
        self.responseHandler = responseHandler
        self.errorHandler = errorHandler
    }
}
