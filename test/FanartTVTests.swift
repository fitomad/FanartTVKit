//
//  FanartTVTests.swift
//  FanartTVTests
//
//  Created by Adolfo Vera Blasco on 18/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import XCTest
@testable import FanartTV

class FanartTVTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Movie Tests
    
    func testMovie()
    {
        // 9340 - Los Goonies
        // 214756 - Ted 2
        // 33427 - Lego (pocos datos)
        // 177271 - Lego (con datos)
        
        // tt0068646 - El Padrino
        
        let expectation: XCTestExpectation = self.expectation(description: "Movies Fanart...")
        
        FanartClient.shared.movie(identifier: 214756 as AnyObject) { (result: FanartResult<MovieArt>) -> (Void) in
            switch result
            {
                case let .error(reason):
                    print("err @ \(#function) -> \(reason)")
                
                case let .success(movie):
                    print("\(movie.name!) # Art available")
                    
                    if let posters = movie.posters, !posters.isEmpty
                    {
                        print("> \(posters.count) posters")
                    }
                    
                    if let clearart = movie.clearartsHD, !clearart.isEmpty
                    {
                        print("> \(clearart.count) HD Clearart")
                    }
                    
                    if let banners = movie.banners, !banners.isEmpty
                    {
                        print("> \(banners.count) banners")
                }
            }
            
            // La operacion asincrona ha terminado
            // Podemos continuar
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    func testMovieTMDB()
    {
        // 9340 - Los Goonies
        // 214756 - Ted 2
        // 33427 - Lego (pocos datos)
        // 177271 - Lego (con datos)
        
        // tt0068646 - El Padrino
        
        let expectation: XCTestExpectation = self.expectation(description: "Movies Fanart...")
        
        FanartClient.shared.movie(tmdb: 9340) { (result: FanartResult<MovieArt>) -> (Void) in
            switch result
            {
            case let .error(reason):
                print("err @ \(#function) -> \(reason)")
                
            case let .success(movie):
                print("\(movie.name!) # Art available")
                
                if let posters = movie.posters, !posters.isEmpty
                {
                    print("> \(posters.count) posters")
                }
                
                if let clearart = movie.clearartsHD, !clearart.isEmpty
                {
                    print("> \(clearart.count) HD Clearart")
                }
                
                if let banners = movie.banners, !banners.isEmpty
                {
                    print("> \(banners.count) banners")
                }
            }
            
            // La operacion asincrona ha terminado
            // Podemos continuar
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    func testMovieIMDB()
    {
        // tt0089218 - Los Goonies
        // tt0068646 - El Padrino
        
        let expectation: XCTestExpectation = self.expectation(description: "Movies Fanart...")
        
        FanartClient.shared.movie(imdb: "tt0089218") { (result: FanartResult<MovieArt>) -> (Void) in
            switch result
            {
            case let .error(reason):
                print("err @ \(#function) -> \(reason)")
                
            case let .success(movie):
                print("\(movie.name!) # Art available")
                
                if let posters = movie.posters, !posters.isEmpty
                {
                    print("> \(posters.count) posters")
                }
                
                if let clearart = movie.clearartsHD, !clearart.isEmpty
                {
                    print("> \(clearart.count) HD Clearart")
                }
                
                if let banners = movie.banners, !banners.isEmpty
                {
                    print("> \(banners.count) banners")
                }
            }
            
            // La operacion asincrona ha terminado
            // Podemos continuar
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    func testLatestMovies()
    {
        let timestamp: Double = Date.unixTimeStampSince(year: 2017, month: 10, day: 4)!
        
        let expectation: XCTestExpectation = self.expectation(description: "Latest Movies.")
        
        FanartClient.shared.latestMovies(since: timestamp) { (results: FanartResult<[MovieUpdate]>) -> (Void) in
            switch results
            {
                case let .error(reason):
                    print("err @ \(#function) -> \(reason)")
                
                case let .success(movies):
                    for movie in movies
                    {
                        print("> \(movie.name!)")
                    }
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    // MARK: - Shows Test
    
    func testShow()
    {
        // Manhattan Love Story
        let showID: Int = 281624
        
        // Closure de rendimiento
        // Se ejecuta 10 veces
        self.measure()
        {
            let expectation: XCTestExpectation = self.expectation(description: "Rendimiento de fanartForShow()")
            
            FanartClient.shared.show(identifier: showID) { (result: FanartResult<ShowArt>) -> (Void) in
                switch result
                {
                    case let .error(reason):
                        print("err @ \(#function) -> \(reason)")
                    
                    case let .success(show):
                        print("# \(show.showName)")
                }
                
                // Operacion asincrona terminada
                expectation.fulfill()
            }

            // Esperamos a que la operacion termine
            self.waitForExpectations(timeout: 10, handler: { (error: Error?) -> Void in
                if let error = error
                {
                    print("testError. \(error.localizedDescription)")
                }
            })
        }
    }
    
    ///
    /// Obtain latest shows updates
    ///
    func testLatestShow() -> Void
    {
        let expectation: XCTestExpectation = self.expectation(description: "Latest Shows...")
        
        if let a_day: TimeInterval = Date.unixTimeStampSince(year: 2017, month: 10, day: 19)
        {
            FanartClient.shared.latestShows(since: a_day) { (results: FanartResult<[ShowUpdate]>) -> (Void) in
                switch results
                {
                    case let .error(reason):
                        print("err @ \(#function) -> \(reason)")
                    
                    case let .success(shows):
                        for show in shows
                        {
                            print("#\(show.name!) has \(show.newImages!) new images of \(show.totalImages!)")
                        }
                }
                
                expectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    // MARK: - Artist Test
    
    func testArtist() -> Void
    {
        // Depeche Mode: 8538e728-ca0b-4321-b7e5-cff6565dd4c0
        // Linkin Park: f59c5520-5f46-4d2c-b2c4-822eabf53419
        // Soda Stereo: 3f8a5e5b-c24b-4068-9f1c-afad8829e06b
        // No existe: false-no-exists-false
        let artistID: String = "8538e728-ca0b-4321-b7e5-cff6565dd4c0"
        
        let expectation: XCTestExpectation = self.expectation(description: "Artists")
        
        FanartClient.shared.musicArtist(identifier: artistID) { (result: FanartResult<MusicArtistArt>) -> (Void) in
            switch result
            {
                case let .error(reason):
                    print("err @ \(#function) -> \(reason)")
                
                case let .success(artist):
                    print("#\(artist.name!)")
                    
                    if let albums = artist.albums
                    {
                        albums.forEach({ print("\($0.albumID)") })
                    }
            }
            
            expectation.fulfill()
        }
            
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    func testAlbum() -> Void
    {
        // Depeche Mode - Singles: 12ee5910-0d55-3fa8-ba24-637670934bdd
        // Meteora: 9ba659df-5814-32f6-b95f-02b738698e7c
        // Linkin Park: f59c5520-5f46-4d2c-b2c4-822eabf53419
        // Soda Stereo: 3f8a5e5b-c24b-4068-9f1c-afad8829e06b
        // No existe: false-no-exists-false
        let albumID: String = "12ee5910-0d55-3fa8-ba24-637670934bdd"
        
        let expectation: XCTestExpectation = self.expectation(description: "Test Album.")
        
        FanartClient.shared.musicAlbum(identifier: albumID) { (result: FanartResult<MusicAlbumArt>) -> (Void) in
            switch result
            {
                case let .error(reason):
                    print("err @ \(#function) -> \(reason)")
                
                case let .success(album):
                    print("#\(album.name)")
                    print("Download image from \(album.albums?[0].covers?[0].url)")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    func testLabel() -> Void
    {
        // Virgin Records Spain: 399a1a44-54b2-4cf2-99be-d95d096eebd3
        // Non Existing Label: not-available-test-only
        let label_id: String = "399a1a44-54b2-4cf2-99be-d95d096eebd3"
        
        let expectation: XCTestExpectation = self.expectation(description: "Music Label Test.")
        
        FanartClient.shared.musicLabel(identifier: label_id, completionHandler: { (result: FanartResult<MusicLabelArt>) -> (Void) in
            switch result
            {
                case let .error(reason):
                    print("err @ \(#function) -> \(reason)")
                
                case let .success(label):
                    print(label.name!)
            }
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    func testLatestArtist() -> Void
    {
        let expectation: XCTestExpectation = self.expectation(description: "Latest Artist Test.")
        
        if let a_day: TimeInterval = Date.unixTimeStampSince(year: 2017, month: 10, day: 19)
        {
            FanartClient.shared.latestArtists(since: a_day, completionHandler: { (results: FanartResult<[MusicUpdate]>) -> (Void) in
                switch results
                {
                    case let .error(reason):
                        print("err @ \(#function) -> \(reason)")
                    case let .success(labels):
                        for label in labels
                        {
                            print("\(label.name!) has \(label.newImages!) new images of \(label.totalImages!)")
                        }
                }
                
                expectation.fulfill()
            })
            
            self.waitForExpectations(timeout: 5000, handler: nil)
        }
    }
}
