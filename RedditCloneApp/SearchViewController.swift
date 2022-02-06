//
//  SearchViewController.swift
//  RedditCloneApp
//
//  Created by Tolga Sayan on 1.02.2022.
//
import UIKit

class SearchViewController: UIViewController {
  
  struct TableView {
    struct CellIdentifiers {
      static let searchResultCell = "SearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
      static let loadingCell = "LoadingCell"
    }
  }
  
 
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  private let search = Search()

  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.text = "flutterdev"
    performSearch()
    var celNib = UINib(
      nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
  
    celNib = UINib(
      nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(
      celNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    celNib = UINib(
      nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
    tableView.register(
      celNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
  }
  
  func showNetworkError() {
    let alert = UIAlertController(
      title: NSLocalizedString("Whoops...", comment: "Network error alert title"),
      message: NSLocalizedString("There was an error accessing the iTunes Store." +
      " Please try again.", comment: "Network error alert message"),
      preferredStyle: .alert)

    let action = UIAlertAction(
      title: NSLocalizedString("OK", comment: "OK button title"), style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
//MARK: - SearchViewController Delegate

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }
  //MARK: - URLSession
  
  func performSearch() {
      search.performSearch(for: searchBar.text ?? "flutterdev") { success in
        if !success {
          self.showNetworkError()
        }
        self.tableView.reloadData()
        
      }

      tableView.reloadData()
      searchBar.resignFirstResponder()
    
      
   
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}
//MARK: - TableView Delegate and DataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(
    _ tableView: UITableView, numberOfRowsInSection section: Int
  ) -> Int {
    switch search.state {
    case .notSearchedYet:
      return 0
    case .loading:
      return 1
    case .noResults:
      return 1
    case .results(let list):
      return list.count
    }
  }
  
  func tableView(
    _ tableView: UITableView, cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    switch search.state {
    case .notSearchedYet:
      fatalError("Should never get here")

    case .loading:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.loadingCell,
        for: indexPath)

      let spinner = cell.viewWithTag(50) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell

    case .noResults:
      return tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
        for: indexPath)

    case .results(let list):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.searchResultCell,
        for: indexPath) as! SearchResultCell

      let searchResult = list[indexPath.row]
      cell.configure(for: searchResult.data)
      return cell
    }
  }
  
  func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
  }
  
  func tableView(
    _ tableView: UITableView, willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
    switch search.state {
    case .notSearchedYet, .loading, .noResults:
      return nil
    case .results:
      return indexPath
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail" {
      let destinationVc = segue.destination as! DetailViewController
      destinationVc.str = searchBar.text ?? "flutterdev"
    }
  }
}

