import Foundation

protocol RequestService {
    func makeNetworkCall<ModelType>(_ request: Request<ModelType>)
}

class NASAWebService: RequestService {
    static var baseURL: URL {
        return URL(string: "https://images-api.nasa.gov/")!
    }
    
    let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func makeNetworkCall<ModelType>(_ request: Request<ModelType>) where ModelType : Decodable {
        let baseURL = NASAWebService.baseURL.appendingPathComponent(request.targetPath)
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = request.queryItems.map { URLQueryItem(name: $0, value: $1) }
        guard let requestURL = urlComponents?.url else {
            request.failureHandler(nil)
            return
        }
        
        webService.makeNetworkCall(
            url: requestURL,
            successHandler: { (data) in
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(ModelType.self, from: data)
                    request.successHandler(model)
                } catch let err {
                    request.failureHandler(err)
                }
        },
            errorHandler: request.failureHandler)
    }
}
