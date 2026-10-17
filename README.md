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
