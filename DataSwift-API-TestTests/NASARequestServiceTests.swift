import XCTest
@testable import DataSwift_API_Test

class NASARequestServiceTests: XCTestCase {
    var sut: NASAWebService!
    var dummyWebService: DummyWebService!

    override func setUpWithError() throws {
        dummyWebService = DummyWebService()
        sut = NASAWebService(webService: dummyWebService)
    }
    
    func testServiceConstructsURLCorrectly() {
        let request = DummyRequest()
        sut.makeNetworkCall(request)
        XCTAssertEqual(dummyWebService.storedURL, URL(string: "https://images-api.nasa.gov/?"))
    }
    
    func testMakeNetworkCallSuccess() throws {
        dummyWebService.shouldReturnError = false
        dummyWebService.dataToReturn = try JSONEncoder().encode("string")
        let request = DummyRequest()
        sut.makeNetworkCall(request)
        XCTAssertTrue(request.successHandlerCalled)
        XCTAssertFalse(request.failureHandlerCalled)
    }
    
    func testMakeNetworkCallFailure() {
        dummyWebService.shouldReturnError = true
        let request = DummyRequest()
        sut.makeNetworkCall(request)
        XCTAssertTrue(request.failureHandlerCalled)
        XCTAssertFalse(request.successHandlerCalled)
    }
}

class DummyRequest: Request<String> {
    var successHandlerCalled = false
    var failureHandlerCalled = false
    
    override var successHandler: (String) -> Void {
        return  { [unowned self] _ in
            self.successHandlerCalled = true
        }
    }
    
    override var failureHandler: (Error?) -> Void {
        return { [unowned self] _ in
            self.failureHandlerCalled = true
        }
    }
}
