import XCTest
@testable import DataSwift_API_Test

class ImageSearchViewModelTests: XCTestCase {
    var sut: ImageSearchViewModel!
    var requestService: DummyRequestService!
    var persistenceManager: MockPersistenceManager!

    override func setUpWithError() throws {
        requestService = DummyRequestService()
        persistenceManager = MockPersistenceManager()
        sut = ImageSearchViewModel(service: requestService,
                                   persistenceManager: persistenceManager)
    }
    
    func testFetchSearchResultsPassesOnRequest() {
        sut.fetchSearchResults(forTerm: "foo")
        XCTAssertNotNil(requestService.lastRequest)
    }
    
    func testGivesEmptyResults_whenNoSearch() {
        XCTAssertEqual(sut.countOfItems(), 0)
        XCTAssertNil(sut.resultViewModel(for: 0))
    }
    
    func testGivesValidCount_whenSearchCompleted() {
        sut.fetchSearchResults(forTerm: "foo")
        requestService.callSuccess()
        XCTAssertEqual(sut.countOfItems(), 1)
    }
    
    func testGivesValidResultViewModel_whenSearchCompleted() {
        sut.fetchSearchResults(forTerm: "foo")
        requestService.callSuccess()
        
        let resultViewModel = sut.resultViewModel(for: 0)
        
        XCTAssertEqual(resultViewModel?.title, "Apollo 11 Mission image - Astronaut Edwin Aldrin poses beside th")
        XCTAssertEqual(resultViewModel?.imageLink, "https://images-assets.nasa.gov/image/as11-40-5874/as11-40-5874~thumb.jpg")
        XCTAssertEqual(resultViewModel?.keywords.count, 7)
        XCTAssertNotNil(resultViewModel?.description)
    }
    
    func testDelegateIsCalled_whenSearchFinishesWithSuccess() {
        let delegate = DummyImageSearchDelegate()
        sut.delegate = delegate
        sut.fetchSearchResults(forTerm: "foo")
        XCTAssertFalse(delegate.viewModelDidFinishSearching)
        
        requestService.callSuccess()
        XCTAssertTrue(delegate.viewModelDidFinishSearching)
        XCTAssertEqual(delegate.lastSearchTerm, "foo")
    }
    
    func testDelegateIsCalled_whenSearchFinishesWithFailure() {
        let delegate = DummyImageSearchDelegate()
        sut.delegate = delegate
        sut.fetchSearchResults(forTerm: "foo")
        XCTAssertFalse(delegate.viewModelDidFinishSearching)
        
        requestService.callFailure()
        XCTAssertTrue(delegate.viewModelDidFinishSearching)
        XCTAssertEqual(delegate.lastSearchTerm, "foo")
    }
}

class DummyImageSearchDelegate: ImageSearchViewModelDelegate {
    var viewModelDidFinishSearching = false
    var lastSearchTerm: String?
    
    func viewModel(_ viewModel: ImageSearchViewModel, didFinishSearchWithTerm searchTerm: String) {
        viewModelDidFinishSearching = true
        lastSearchTerm = searchTerm
    }
}

class MockPersistenceManager: SearchResultsPersistenceManager {
    func updateResponse(_ response: ImageSearchResponse, forKey: String) {
        
    }
    
    func getStoredResult(forKey: String) -> ImageSearchResponse? {
        return DummyRequestService.defaultResponse
    }
}
