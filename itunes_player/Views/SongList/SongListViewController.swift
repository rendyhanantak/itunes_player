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
    @IBOutlet weak var activityIndicatorContainerView: UIView!
    @IBOutlet weak var playerView: CustomPlayerView!
    
    private let viewModel = SongListViewModel(apiService: APIService())
    private var playerViewModel: CustomPlayerModel?
    private let audioService = AudioPlayerService()
    
    private var defaultKeyword = "Beyonce" //search api needs keyword, can't searching all song
    
    private var playedTrackId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationView()
        setupSearchBar()
        setupTableView()
        setupPlayerView()
        bindViewModel()
        resetSearch()
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
        tableView.register(
            UINib( nibName: "EmptyTableViewCell", bundle: nil),
            forCellReuseIdentifier: "EmptyTableViewCell"
        )
    }
    
    private func setupPlayerView() {
        playerView.onNextTapped = { [weak self] in
            guard let self else { return }
            self.playerViewModel?.playNext()
        }
        playerView.onPreviousTapped = { [weak self] in
            guard let self else { return }
            self.playerViewModel?.playPrevious()
        }
        playerView.onPlayPauseToggled = { [weak self] isPlayed in
            guard let self else { return }
            self.playerViewModel?.togglePlayPause()
        }
        playerView.onSliderValueChanged = { [weak self] value in
            guard let self else { return }
            self.playerViewModel?.seek(to: Double(value))
        }
    }
    
    private func bindViewModel() {
        viewModel.onSongsUpdated = { [weak self] in
            guard let self else { return }
            self.playerViewModel = CustomPlayerModel(
                songs: viewModel.songs,
                selectedIndex: 0,
                audioService: audioService
            )
            self.bindPlayerViewModel()
            self.playerViewModel?.play()
            self.tableView.reloadData()
        }

        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                self.activityIndicatorContainerView.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.activityIndicatorContainerView.isHidden = true
                self.tableView.isHidden = false
            }
        }

        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                )
            )
            self?.present(alert, animated: true)
        }
    }
    
    private func resetSearch() {
        searchBar.searchTextField.text = defaultKeyword
        viewModel.searchSongs(keyword: defaultKeyword)
    }
}

extension SongListViewController {
    private func bindPlayerViewModel() {
        playerViewModel?.onSongChanged = { [weak self] song in
            self?.playedTrackId = song.trackId
            self?.tableView.reloadData()
        }
        playerViewModel?.onPlaybackStateChanged = {
            [weak self] isPlaying in
            self?.playerView.configure(isPlayed: isPlaying)
        }
        playerViewModel?.onProgressChanged = {
            [weak self] currentTime, duration in
            guard let self else {
                return
            }
            self.playerView.configure(sliderMaxValue: Float(max(duration, 1)), sliderValue: Float(currentTime))
        }
    }
}

extension SongListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalData = viewModel.totalSongs()
        if totalData < 1 {
            return 1
        }
        return totalData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.totalSongs() > 0 else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as? EmptyTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(keyword: searchBar.text ?? "")
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListTableViewCell", for: indexPath) as? SongListTableViewCell else {
            return UITableViewCell()
        }
        let song = viewModel.song(position: indexPath.row)
        cell.configure(song: song, playedTrackId: self.playedTrackId)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playerView.resetSlider()
        playerViewModel?.reset(to: indexPath.row)
        playerViewModel?.play()
    }
}

extension SongListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let keyword = searchBar.text,
              !keyword.isEmpty else {
            resetSearch()
            return
        }
        playerViewModel?.reset()
        viewModel.searchSongs(keyword: keyword)
    }
}
