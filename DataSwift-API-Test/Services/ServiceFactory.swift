import Foundation

protocol ServiceFactory {
    func getWebService() -> WebService
    func getRequestService() -> RequestService
    func getImageService() -> ImageService
}

class BaseServiceFactory: ServiceFactory {
    private let webService: WebService
    private let requestService: RequestService
    private let imageService: ImageService
    
    init() {
        webService = NativeWebService(timeoutInterval: 30.0)
        requestService = NASAWebService(webService: webService)
        imageService = WebImageService(webService: webService)
    }
    
    func getWebService() -> WebService {
        return webService
    }
    
    func getRequestService() -> RequestService {
        return requestService
    }
    
    func getImageService() -> ImageService {
        return imageService
    }
}
