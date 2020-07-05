import Foundation

protocol WebService {
    func makeNetworkCall(url: URL,
                         successHandler: @escaping (Data) -> Void,
                         errorHandler: @escaping (Error?) -> Void)
}

class NativeWebService: WebService {
    let timeoutInterval: Double
    
    init(timeoutInterval: Double = 60.0) {
        self.timeoutInterval = timeoutInterval
    }
    
    func makeNetworkCall(url: URL,
                         successHandler: @escaping (Data) -> Void,
                         errorHandler: @escaping (Error?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeoutInterval
        let urlSession = URLSession(configuration: sessionConfig)
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                errorHandler(error)
                return
            }
            
            successHandler(data)
        }
        task.resume()
    }
}
