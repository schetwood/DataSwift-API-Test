import Foundation
@testable import DataSwift_API_Test

class DummyRequestService: RequestService {
    var lastRequest: ImageSearchRequest?
    
    func makeNetworkCall<ModelType>(_ request: Request<ModelType>) where ModelType : Decodable {
        guard let imageSearchRequest = request as? ImageSearchRequest else {
            return
        }
        lastRequest = imageSearchRequest
    }
    
    lazy var defaultResponse: ImageSearchResponse = {
        let filepath = Bundle(for: type(of: self)).path(forResource: "example", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filepath))
        let response = try! JSONDecoder().decode(ImageSearchResponse.self, from: data)
        return response
    }()
    
    func callSuccess(response: ImageSearchResponse? = nil) {
        let successResponse = response ?? defaultResponse
        lastRequest?.successHandler(successResponse)
    }

    func callFailure(error: Error? = nil) {
        lastRequest?.failureHandler(error)
    }
}
