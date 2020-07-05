import XCTest
@testable import DataSwift_API_Test

class WebImageServiceTests: XCTestCase {
    var sut: WebImageService!
    var webService: DummyWebService!
    
    let exampleTarget = "https://google.com"
    lazy var sampleImageData: Data = {
        let filepath = Bundle(for: type(of: self))
            .path(forResource: "icons8-thick-arrow-pointing-down-30", ofType: "png")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filepath))
        return data
    }()

    override func setUpWithError() throws {
        webService = DummyWebService()
        sut = WebImageService(webService: webService)
    }
    
    func testFetchImageCallsNetwork() {
        let expectation = XCTestExpectation(description: "fetch image")
        sut.fetchImage(target: exampleTarget) { (_, _) in
            XCTAssertTrue(self.webService.makeNetworkCallCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchImagePreservesTarget() {
        let expectation = XCTestExpectation(description: "fetch image")
        sut.fetchImage(target: exampleTarget) { (_, target) in
            XCTAssertEqual(target, self.exampleTarget)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchImagePassesBackUIImage() {
        webService.dataToReturn = sampleImageData
        
        let expectation = XCTestExpectation(description: "fetch image")
        sut.fetchImage(target: exampleTarget) { (image, _) in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchingSameImageDoesNotPromptNetworkCall() {
        webService.dataToReturn = sampleImageData
        
        let expectation = XCTestExpectation(description: "Second fetch")
        sut.fetchImage(target: exampleTarget) { (_, target) in
            self.webService.makeNetworkCallCalled = false
            self.sut.fetchImage(target: target) { (_, _) in
                XCTAssertFalse(self.webService.makeNetworkCallCalled)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

}
