//
//  SpotifyManagerTests.swift
//  MorningFormulaTests
//
//  Created by Spencer Belton on 10/20/23.
//

import XCTest
@testable import MorningFormula

final class SpotifyManagerTests: XCTestCase {

    var spotifyManager: SpotifyManager!

    override func setUp() {
        super.setUp()
        spotifyManager = SpotifyManager(spotifyService: MockSpotifyService())
    }
    
    override func tearDown() {
        spotifyManager = nil
        super.tearDown()
    }

    func testTimerStarts() {
        spotifyManager.startTimer(duration: 2)
        
        let expectation = XCTestExpectation(description: "Timer Expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertNotNil(spotifyManager.accessTokenTimer)

    }
}


class MockSpotifyService: SpotifyService {
    
    func getAccessToken(withCompletion completion: @escaping (String?, Error?) -> Void) {
        completion("MockAccessToken", nil)
    }
    
    func getSongFromSearch(accessCode: String, _ query: String, withCompletion completion: @escaping (MorningFormula.SpotifyRoot?, Error?) -> Void) {
        let mockItems = SpotifyItem.examples
        let mockTrack = Track(items: mockItems)
        
        let mockRoot = SpotifyRoot(tracks: mockTrack)
        completion(mockRoot, nil)
    }
    
    func urlRequestFromQuery(accessCode: String, _ query: String) -> URLRequest? {
        return nil
    }
    
    
}
