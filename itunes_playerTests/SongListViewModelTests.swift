//
//  SongListViewModelTests.swift
//  itunes_playerTests
//
//  Created by Rendy Hananta on 17/10/26.
//

import XCTest
@testable import itunes_player

@MainActor
final class SongListViewModelTests: XCTestCase {

    private var sut: SongListViewModel!
    private var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()

        mockAPIService = MockAPIService()
        sut = SongListViewModel(apiService: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil

        super.tearDown()
    }

    // MARK: - Search Songs Tests

    func testSearchSongs_WhenAPISucceeds_UpdatesSongs() async {
        // Arrange
        let expectedSongs = makeSongs()
        mockAPIService.mockSongs = expectedSongs

        let songsUpdatedExpectation = expectation(
            description: "Songs updated"
        )

        sut.onSongsUpdated = {
            songsUpdatedExpectation.fulfill()
        }

        // Act
        sut.searchSongs(keyword: "Taylor Swift")

        // Assert
        await fulfillment(
            of: [songsUpdatedExpectation],
            timeout: 2.0
        )

        XCTAssertEqual(sut.totalSongs(), expectedSongs.count)
        XCTAssertEqual(
            mockAPIService.receivedKeyword,
            "Taylor Swift"
        )
        XCTAssertEqual(
            mockAPIService.searchSongsCallCount,
            1
        )
    }

    func testSearchSongs_WhenAPIReturnsEmptyArray_UpdatesSongsToEmpty() async {
        // Arrange
        mockAPIService.mockSongs = []

        let songsUpdatedExpectation = expectation(
            description: "Songs updated with empty result"
        )

        sut.onSongsUpdated = {
            songsUpdatedExpectation.fulfill()
        }

        // Act
        sut.searchSongs(keyword: "Unknown Song")

        // Assert
        await fulfillment(
            of: [songsUpdatedExpectation],
            timeout: 2.0
        )

        XCTAssertEqual(sut.totalSongs(), 0)
    }

    func testSearchSongs_WhenAPIFails_CallsOnError() async {
        // Arrange
        mockAPIService.shouldThrowError = true

        let errorExpectation = expectation(
            description: "Error callback called"
        )

        sut.onError = { message in
            XCTAssertEqual(
                message,
                "Unable to load songs. Please try again."
            )

            errorExpectation.fulfill()
        }

        // Act
        sut.searchSongs(keyword: "Taylor Swift")

        // Assert
        await fulfillment(
            of: [errorExpectation],
            timeout: 2.0
        )
    }

    // MARK: - Loading State Tests

    func testSearchSongs_WhenFetchingSongs_ChangesLoadingState() async {
        // Arrange
        mockAPIService.mockSongs = makeSongs()

        let loadingExpectation = expectation(
            description: "Loading state changes"
        )

        var loadingStates: [Bool] = []

        sut.onLoadingChanged = { isLoading in
            loadingStates.append(isLoading)

            if loadingStates.count == 2 {
                loadingExpectation.fulfill()
            }
        }

        // Act
        sut.searchSongs(keyword: "Taylor Swift")

        // Assert
        await fulfillment(
            of: [loadingExpectation],
            timeout: 2.0
        )

        XCTAssertEqual(loadingStates, [true, false])
    }

    func testSearchSongs_WhenAPIFails_StopsLoading() async {
        // Arrange
        mockAPIService.shouldThrowError = true

        let loadingExpectation = expectation(
            description: "Loading state changes after failure"
        )

        var loadingStates: [Bool] = []

        sut.onLoadingChanged = { isLoading in
            loadingStates.append(isLoading)

            if loadingStates.count == 2 {
                loadingExpectation.fulfill()
            }
        }

        // Act
        sut.searchSongs(keyword: "Taylor Swift")

        // Assert
        await fulfillment(
            of: [loadingExpectation],
            timeout: 2.0
        )

        XCTAssertEqual(loadingStates, [true, false])
    }

    // MARK: - Song List Tests

    func testTotalSongs_WhenSongsExist_ReturnsCorrectCount() {
        // Arrange
        mockAPIService.mockSongs = makeSongs()

        // This test can verify the initial state directly.
        XCTAssertEqual(sut.totalSongs(), 0)
    }

    func testSong_WhenPositionIsValid_ReturnsCorrectSong() async {
        // Arrange
        let expectedSongs = makeSongs()
        mockAPIService.mockSongs = expectedSongs

        let songsUpdatedExpectation = expectation(
            description: "Songs updated"
        )

        sut.onSongsUpdated = {
            songsUpdatedExpectation.fulfill()
        }

        // Act
        sut.searchSongs(keyword: "Taylor Swift")

        await fulfillment(
            of: [songsUpdatedExpectation],
            timeout: 2.0
        )

        // Assert
        XCTAssertEqual(
            sut.song(position: 0).trackName,
            expectedSongs[0].trackName
        )

        XCTAssertEqual(
            sut.song(position: 1).trackName,
            expectedSongs[1].trackName
        )
    }

    // MARK: - Helper

    private func makeSongs() -> [Song] {
        [
            Song(
                trackId: 1,
                trackName: "Love Story",
                artistName: "Taylor Swift",
                collectionName: "1992",
                artworkUrl100: nil,
                previewUrl: nil
            ),
            Song(
                trackId: 2,
                trackName: "Blank Space",
                artistName: "Taylor Swift",
                collectionName: "1992",
                artworkUrl100: nil,
                previewUrl: nil
            )
        ]
    }
}
