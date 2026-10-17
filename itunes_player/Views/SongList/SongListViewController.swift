//
//  SongListViewController.swift
//  itunes_player
//
//  Created by Rendy Hananta on 16/10/26.
//

import UIKit

class SongListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationView()
        setupSearchBar()
        setupTableView()
    }
    
    private func setupNavigationView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib( nibName: "SongListTableViewCell", bundle: nil),
            forCellReuseIdentifier: "SongListTableViewCell"
        )
    }
}

extension SongListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Change to data count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListTableViewCell", for: indexPath) as? SongListTableViewCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
}

extension SongListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text,
              !keyword.isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        //TODO: filter data and refresh table view
    }
}
