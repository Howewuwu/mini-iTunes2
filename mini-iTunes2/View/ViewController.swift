//
//  ViewController.swift
//  mini-iTunes2
//
//  Created by Howe on 2023/3/21.
//

import UIKit

class ViewController: UIViewController {
    
    var items = [iTunesItem]()
    var offset = 0
    let section = "tw"
    
    @IBOutlet weak var searchResult: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        super.viewDidLoad()
    }
    
    func searchMusic(query: String) {
        items = []
        searchResult.text = "搜尋中..."
        Search.shared.searchMusic(searchTerm: query, offset: offset, country: section) { result in
            switch result {
            case.success(let musicList):
                DispatchQueue.main.async {
                    self.offset = 0
                    self.items = musicList
                    self.searchResult.text = "搜尋到\(self.items.count)個結果"
                    self.tableView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.searchResult.text = "未找到符合項目"
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    func configure(cell: musicCell, forRowAt indexPath:IndexPath) {
        let itemsResults = items[indexPath.row]
        cell.trackName.text = itemsResults.trackName
        cell.artistName.text = itemsResults.artistName
        cell.collectionName.text = itemsResults.collectionName
        
        Search.shared.searchImage(from: itemsResults.artworkUrl100) { results in
            switch results{
            case.success(let image):
                DispatchQueue.main.async {
                    if indexPath == self.tableView.indexPath(for: cell){
                        cell.artworkUrl100.image = image
                    }
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    cell.artworkUrl100.image = UIImage(systemName: "photo")
                }
            }
        }
        
    }
    
    //SelectDetail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: selectedItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let detailVC = segue.destination as? DetailViewController,
           let selectedItem = sender as? iTunesItem {
            detailVC.selectedItem = selectedItem
        }
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as? musicCell else {return UITableViewCell()}
        if items.isEmpty == false {
            configure(cell: cell, forRowAt: indexPath)
        }
        return cell
        
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else { return }
        searchMusic(query: searchText)
        searchBar.resignFirstResponder()
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
        
    }
}
