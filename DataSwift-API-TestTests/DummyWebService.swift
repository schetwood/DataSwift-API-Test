import Foundation
@testable import DataSwift_API_Test

class DummyWebService: WebService {
    var makeNetworkCallCalled = false
    var storedURL: URL?
    var shouldReturnError = false
    var dataToReturn: Data = "".data(using: .utf8)!
    var errorToReturn: Error?
    
    func makeNetworkCall(url: URL,
                         successHandler: @escaping (Data) -> Void,
                         errorHandler: @escaping (Error?) -> Void) {
        makeNetworkCallCalled = true
        storedURL = url
        if shouldReturnError {
            errorHandler(errorToReturn)
        } else {
            successHandler(dataToReturn)
        }
    }
}
