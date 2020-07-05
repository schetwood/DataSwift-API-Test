import UIKit

typealias ImageCompletion = (_ image: UIImage?, _ target: String) -> Void

protocol ImageService {
    func fetchImage(target: String, completion: @escaping ImageCompletion)
}

class WebImageService: ImageService {
    let webService: WebService
    let imageCache:NSCache<NSString, UIImage>
    
    init(webService: WebService) {
        self.webService = webService
        imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 100
    }
    
    func fetchImage(target: String, completion: @escaping ImageCompletion) {
        guard let targetURL = URL(string: target) else {
            completion(nil, target)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: target as NSString) {
            completion(cachedImage, target)
            return
        }
        
        webService.makeNetworkCall(
            url: targetURL,
            successHandler: {[weak self] (data) in
                guard let image = UIImage(data: data) else {
                    completion(nil, target)
                    return
                }
                DispatchQueue.main.async {
                    self?.imageCache.setObject(image, forKey: target as NSString)
                    completion(image, target)
                }
            },
            errorHandler: { _ in
                completion(nil, target)
        })
    }
}
