import Foundation

protocol ImageSearchViewModelDelegate: class {
    func viewModel(_ viewModel: ImageSearchViewModel, didFinishSearchWithTerm: String)
}

class ImageSearchViewModel {
    private let requestService: RequestService
    private var response: ImageSearchResponse? {
        guard let lastSearchTerm = mostRecentSearchTerm else { return nil }
        return persistenceManager.getStoredResult(forKey: lastSearchTerm)
    }
    
    weak var delegate: ImageSearchViewModelDelegate?
    
    private var mostRecentSearchTerm: String?
    private let persistenceManager: SearchResultsPersistenceManager
    
    init(service: RequestService, persistenceManager: SearchResultsPersistenceManager) {
        self.requestService = service
        self.persistenceManager = persistenceManager
    }
    
    func fetchSearchResults(forTerm searchTerm: String) {
        mostRecentSearchTerm = searchTerm
        let request = ImageSearchRequest(
            query: searchTerm,
            responseHandler: { [weak self] response in
                guard let self = self else { return }
                self.persistenceManager.updateResponse(response, forKey: searchTerm)
                self.delegate?.viewModel(self, didFinishSearchWithTerm: searchTerm)
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
                print("Error: \(error?.localizedDescription ?? "nil")")
                self.delegate?.viewModel(self, didFinishSearchWithTerm: searchTerm)
        })
        requestService.makeNetworkCall(request)
    }
    
    func countOfItems() -> Int {
        return response?.collection?.items?.count ?? 0
    }
    
    func resultViewModel(for index: Int) -> SearchResultViewModel? {
        guard let item = response?.collection?.items?[index] else {
            return nil
        }
        
        let title = item.data?.first?.title
        let description = item.data?.first?.description
        let keywords = item.data?.first?.keywords
        let imageLink = item.links?.first(where: { $0.render == "image" })?.href
        
        return SearchResultViewModel(title: title,
                                     description: description,
                                     keywords: keywords ?? [],
                                     imageLink: imageLink)
    }
}
