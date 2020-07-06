import UIKit

class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    var serviceFactory: ServiceFactory!
    
    private var viewModel: ImageSearchViewModel!
    private var imageService: WebImageService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ImageSearchViewModel(service: serviceFactory.getRequestService(),
                                         persistenceManager: serviceFactory.getPersistenceManager())
        viewModel.delegate = self
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: SearchResultTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: NoResultsTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: NoResultsTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        searchBar.delegate = self
    }
    
    func search(withTerm searchTerm: String) {
        view.endEditing(true)
        loadingIndicator.startAnimating()
        loadingView.isHidden = false
        viewModel.fetchSearchResults(forTerm: searchTerm)
    }
    
    @IBAction func tappedSearch(_ sender: Any) {
        search(withTerm: searchBar.text ?? "")
    }
    
}

extension SearchViewController: UITableViewDataSource {
    private var shouldShowNoResults: Bool {
        return viewModel.countOfItems() == 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowNoResults {
            return 1
        } else {
            return viewModel.countOfItems()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !shouldShowNoResults else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NoResultsTableViewCell.reuseIdentifier,
                for: indexPath)
            return cell
        }
        
        guard let rowViewModel = viewModel.resultViewModel(for: indexPath.row) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.reuseIdentifier,
            for: indexPath)
        
        if let resultCell = cell as? SearchResultTableViewCell {
            resultCell.setup(with: rowViewModel, imageService: serviceFactory.getImageService())
        }
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(withTerm: searchBar.text ?? "")
    }
}

extension SearchViewController: ImageSearchViewModelDelegate {
    func viewModel(_ viewModel: ImageSearchViewModel, didFinishSearchWithTerm: String) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.loadingView.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
    }
}
