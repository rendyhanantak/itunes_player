# itunes_player
simple app to play music from itunes

🎵 Music Player AppA lightweight, responsive web-based music application that allows users to search, stream, and control music playback. Powered by the iTunes Search API, this app fetches track information and continuous 30-second audio previews dynamically.   

✨ Features
Track Listing: Browse and search through songs fetched in real time from the iTunes API.
Skip to the Next or Previous song in the playlist queue.
Seek Slider: Scrub through the current playing position using an interactive audio progress bar.
Continuous Auto-Play: Automatically plays the next song when the current track finishes.
Interactive UI: Active playing indicators, track metadata displays (artist name, album art), and continuous time/duration updates.

🔌 API Integration
This application fetches data dynamically using the iTunes Search API.
Primary Endpoint: GET https://itunes.apple.com/search?term={searchkeywords}&entity=song

📁 Project Structure
itunes_player
 - Models
    - SearchResponse.swift
    - Song.swift
 - Services
     - APIService.swift
     - AudioPlayerService.swift
 - ViewModels
     - CustomPlayerModel.swift
     - SongListViewModel.swift
 - Views
   - App
     - AppDelegate.swift
     - SceneDelegate.swift
   - SongList
     - CustomPlayerView.swift
     - CustomPlayerView.xib
     - EmptyTableViewCell.swift
     - EmptyTableViewCell.xib
     - SongListTableViewCell.swift
     - SongListTableViewCell.xib
     - SongListViewController.swift
     - SongListViewController.xib

How to use:
- Default search is "Beyonce" because the api cannot search all and must send keywords
- When song selected, it will play the music and it will auto play next song.
- When song selected, music control will be visible and can play/pause music, can go to next song, and can go to previous song
- There is slider to control music played, go to specific time based on slider

Demo:

https://github.com/user-attachments/assets/710600f1-2dee-444f-9815-4febfd389e4b

<img width="20%" alt="song_list_played" src="https://github.com/user-attachments/assets/ffeabbf5-bafb-45a3-a961-cc640213703c" />
<img width="20%" alt="song_list_no_internet" src="https://github.com/user-attachments/assets/d9ce5bf2-38fd-49e8-8154-09aad602621a" />
<img width="20%" alt="song_list_loading_state" src="https://github.com/user-attachments/assets/ad28cf08-33ae-492e-8ede-9ac2ef3f7fc2" />
<img width="20%" alt="song_list_empty_result" src="https://github.com/user-attachments/assets/091d43c9-4c24-4e61-87ba-e4f256b70c57" />

