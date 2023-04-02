import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var viewModel = SearchViewModel()
    var coordinator: RootCoordinator?
    
    private func setupTableView() {
        table.register(nib: SearchCell.self)
        table.delegate = self
        table.dataSource = self
        viewModel.reloadUI = { [weak self] in
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        if let result = viewModel.searchResult?[indexPath.row] {
            coordinator?.presentDetailFor(searchResult: result)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCell = table.dequeueReusableCell(forIndexPath: indexPath)
        if let result = viewModel.searchResult?[indexPath.row] {
            cell.configure(for: result)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResult?.count ?? 0
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searching(text: searchText)
    }
}
