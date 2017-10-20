//
//  FanartClient.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 20/10/17.
//  Copyright © 2017 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

// MARK:- Completion Handlers

///
/// Art related a show, movie, music...
///
public typealias FanartCompletionHandler<T> = (_ result: T) -> (Void)

///
/// An image requested to Fanart.TV will be find here...
///
public typealias ImageRequestCompletionHandler = (_ image: Data?) -> (Void)

///
/// All API request will be *returned* here
///
private typealias HttpRequestCompletionHandler = (_ results: AnyObject?, _ error: Error?) -> (Void)

// MARK:- Alias for music update class

///
/// Cause the data struct is the same as **ShowUpdate** there is
/// no nedd to create a new class, simply make an alias
///
public typealias MusicUpdate = ShowUpdate

///
/// Network client for Fanart.TV API 
///
public final class FanartClient
{

    /// Singleton instance
    public static let shared: FanartClient = FanartClient()
    
    /// Your Fanart.TV  project/personal api key
    private let apiKey: String = "YOUR-API-KEY"
    /// All the api request starts with this.
    private let baseURL: String = "https://webservice.fanart.tv/v3"

    /// The API client HTTP session
    private var httpSession: URLSession!
    /// API client HTTP configuration
    private var httpConfiguration: URLSessionConfiguration!

    /// The object dedicated to convert from JSON data
    /// obtained from Fanart.TV to out own data structures
    private var parser: FanartParser
    
    /**
        Initialize and set up the network connection
    */
    private init()
    {
        self.parser = FanartParser()

        self.httpConfiguration = URLSessionConfiguration.default
        self.httpConfiguration.httpMaximumConnectionsPerHost = 10

        let http_queue: OperationQueue = OperationQueue()
        http_queue.maxConcurrentOperationCount = 10

        self.httpSession = URLSession(configuration:self.httpConfiguration,
                                             delegate:nil,
                                        delegateQueue:http_queue)
    }
    
    //
    // MARK:- Movies
    //
    
    /**
         Request movie images from a [TMDB](https://www.themoviedb.org) identifier
     
         - Parameters:
             - tmdb: Identifier from The Movie Database
             - completionHandler: Closure in which put the results
     
         - SeeAlso: movie(identifier:completionHandler:)
    */
    public func movie(tmdb: Int, completionHandler: @escaping FanartCompletionHandler<FanartResult<MovieArt>>) -> Void
    {
        self.movie(identifier: tmdb as AnyObject, completionHandler: completionHandler)
    }
    
    /**
         Request movie images from an [IMDB](http://imdb.com) identifier
     
         - Parameters:
            - imdb: Identifier from Internet Movie Database
            - completionHandler: Closure in which put the results
     
         - SeeAlso: movie(identifier:completionHandler:)
    */
    public func movie(imdb: String, completionHandler: @escaping FanartCompletionHandler<FanartResult<MovieArt>>) -> Void
    {
        self.movie(identifier: imdb as AnyObject, completionHandler: completionHandler)
    }
    
    
    /**
        Request all resources for a movie whatever the
        identifier comes from.

        - Parameter movieID: A tmdb_id, imdb_id or future source valid identificator
        - Parameter completionHandler: Closure in which put the results
    */
    public func movie(identifier movieID: AnyObject, completionHandler: @escaping FanartCompletionHandler<FanartResult<MovieArt>>) -> Void
    {
        guard movieID is Int || movieID is String else
        {
            return
        }
        
        let web_resource: String = "\(self.baseURL)/movies/\(movieID)?api_key=\(self.apiKey)"
        let url: URL = URL(string: web_resource)!

        self.processHttpRequest(from: url, httpHandler: { (results: AnyObject?, error: Error?) -> (Void) in
            // Parsing JSON to Movie
            guard let results = results, let data = results as? [String: AnyObject] else
            {
                completionHandler(FanartResult.error(reason: "No data found"))
                return
            }

            // Parse JSON to Movie
            let movieArt: MovieArt = self.parser.parseMovie(from: data)
            completionHandler(FanartResult.success(result: movieArt))
            }
        )
    }
    
    /**
        Last movies affected by changes from a date

        - Parameter date: Movies updated from this date to Now
        - Parameter completionHandler: Data response
    */
    public func latestMovies(since date: TimeInterval, completionHandler: @escaping FanartCompletionHandler<FanartResult<[MovieUpdate]>>) -> Void
    {
        let timestamp: Int = Int(date)
        let web_resource: String = "\(self.baseURL)/movies/latest?api_key=\(self.apiKey)&date=\(timestamp)"
        let url: URL = URL(string: web_resource)!

        self.processHttpRequest(from: url, httpHandler: { (results: AnyObject?, error: Error?) -> (Void) in
            // Parse JSON to Movie
            guard let results = results, let datos = results as? [[String: AnyObject]] else
            {
                completionHandler(FanartResult.error(reason: "No data"))
                return
            }

            let updates: [MovieUpdate] = self.parser.parseLatestMovies(from: datos)
            completionHandler(FanartResult.success(result: updates))
            }
        )
    }
    
    //
    // MARK:- Shows
    //
    
    /**
        All images availables for a TV Show
    
        - Parameter showID: The TVDB identifier for the show
        - Parameter completionHandler: Here we return the results
    */
    public func show(identifier showID: Int, completionHandler: @escaping FanartCompletionHandler<FanartResult<ShowArt>>) -> Void
    {
        let web_resource: String = "\(self.baseURL)/tv/\(showID)?api_key=\(self.apiKey)"
        let url: URL = URL(string: web_resource)!
        
        self.processHttpRequest(from: url, httpHandler: { (results: AnyObject?, error: Error?) -> (Void) in
            // Parse JSON to TV Show
            guard let results = results, let datos = results as? [String: AnyObject] else
            {
                completionHandler(FanartResult.error(reason: "No data"))
                return
            }

            // Parse JSON to Show
            let showArt: ShowArt = self.parser.parseShow(from: datos)
            completionHandler(FanartResult.success(result: showArt))
            }
        )
    }
    
    /**
        Last shows affected by changes since the date
     
        - Parameter date: Movies updated from this date to Now
        - Parameter completionHandler:
     */
    public func latestShows(since date: TimeInterval, completionHandler: @escaping FanartCompletionHandler<FanartResult<[ShowUpdate]>>) -> Void
    {
        let timestamp: Int = Int(date)
        let web_resource: String = "\(self.baseURL)/tv/latest?api_key=\(self.apiKey)&date=\(timestamp)"
        let url: URL = URL(string: web_resource)!
        
        self.processHttpRequest(from: url, httpHandler: { (results: AnyObject?, error: Error?) -> (Void) in
            // Parse JSON to Show
            if let results = results, let datos = results as? [[String: AnyObject]]
            {
                let updates: [ShowUpdate] = self.parser.parseLatestShows(from: datos)
                completionHandler(FanartResult.success(result: updates))
            }
            else
            {
                completionHandler(FanartResult.error(reason: "No data available"))
            }
        })
    }
    
    //
    // MARK:- Music
    //
    
    /**
        All images availables for this music artist
    
        - Parameter artisID: The Musicbrainz identifier for the artist
        - Parameter completionHandler: Here we return the results
    */
    public func musicArtist(identifier artisID: String, completionHandler: @escaping FanartCompletionHandler<FanartResult<MusicArtistArt>>) -> Void
    {
        let web_resource: String = "\(self.baseURL)/music/\(artisID)?api_key=\(self.apiKey)"
        let url: URL = URL(string: web_resource)!
        
        self.processHttpRequest(from: url, httpHandler: { (results: AnyObject?, error: Error?) -> (Void) in
            // Parse JSON to Music Artist
            guard let results = results, let datos = results as? [String: AnyObject] else
            {
                completionHandler(FanartResult.error(reason: "No data available"))
                return
            }

            let musicArtistArt: MusicArtistArt = self.parser.parseArtist(from: datos)
            completionHandler(FanartResult.success(result: musicArtistArt))
        })
    }

    /**
        All images availables for this music label
    
        - Parameter labelID: The Musicbrainz identifier for the label
        - Parameter completionHandler: Here we return the results
    */
    public func musicLabel(identifier labelID: String, completionHandler: @escaping FanartCompletionHandler<FanartResult<MusicLabelArt>>) -> Void
    {
        let web_resource: String = "\(self.baseURL)/music/labels/\(labelID)?api_key=\(self.apiKey)"
        let url: URL = URL(string: web_resource)!
        
        self.processHttpRequest(from: url, httpHandler: { (results: AnyObject?, error: Error?) -> (Void) in
            // Parse JSON to Music Label
            guard let results = results, let datos = results as? [String: AnyObject] else
            {
                completionHandler(FanartResult.error(reason: "No data available"))
                return
            }

            let musicLabelArt: MusicLabelArt = self.parser.parseLabel(from: datos)
            completionHandler(FanartResult.success(result: musicLabelArt))
        })
    }

    /**
        All images availables for this music album
    
        - Parameter albumID: The Musicbrainz identifier for the album
        - Parameter completionHandler: Here we return the results
    */
    public func musicAlbum(identifier albumID: String, completionHandler: @escaping FanartCompletionHandler<FanartResult<MusicAlbumArt>>) -> Void
    {
        let web_resource: String = "\(self.baseURL)/music/albums/\(albumID)?api_key=\(self.apiKey)"
        let url: URL = URL(string: web_resource)!
        
        self.processHttpRequest(from: url, httpHandler: { (results: AnyObject?, error: Error?) -> (Void) in
            // Parse JSON to Music Album
            guard let results = results, let datos = results as? [String: AnyObject] else
            {
                completionHandler(FanartResult.error(reason: "No data available"))
                return
            }

            let musicAlbumArt: MusicAlbumArt = self.parser.parseAlbum(from: datos)
            completionHandler(FanartResult.success(result: musicAlbumArt))
        })
    }

    /**
        Last music artist affected by changes since the date
     
        - Parameter date: Music Artist updated from this date to Now
        - Parameter completionHandler: The updates will be passed here
     */
    public func latestArtists(since date: TimeInterval, completionHandler: @escaping FanartCompletionHandler<FanartResult<[MusicUpdate]>>) -> Void
    {
        let timestamp: Int = Int(date)
        let web_resource: String = "\(self.baseURL)/music/latest?api_key=\(self.apiKey)&date=\(timestamp)"
        let url: URL = URL(string: web_resource)!
        
        self.processHttpRequest(from: url, httpHandler: { (results: AnyObject?, error: Error?) -> (Void) in
            // Parse JSON to Artists
            guard let results = results, let datos = results as? [[String: AnyObject]] else
            {
                completionHandler(FanartResult.error(reason: "No data available"))
                return
            }
            
            // Call the `latestShowsFromJSON` cause the resultant 
            // structure is the same. Remember that `MusicUpdate`
            // is just an alias for `ShowUpdate` class
            let updates: [MusicUpdate] = self.parser.parseLatestShows(from: datos)
            completionHandler(FanartResult.success(result: updates))
        })
    }

    //
    // MARK:- Image download
    //

    /**
        Request an image resource to Fanart.TV

        - Parameter url: The image URL
        - Parameter completionHandler: The operation result will be passed here.
    */
    public func downloadImage(from url: URL, completionHandler: @escaping ImageRequestCompletionHandler) -> Void
    {
        let request: URLRequest = URLRequest(url: url)

        let data_task: URLSessionDataTask = self.httpSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let data = data,
               let http_response = response as? HTTPURLResponse,
               http_response.statusCode == 200
            {
                completionHandler(data)
            }
            else 
            {
                completionHandler(nil)
            }
        })

        data_task.resume()
    }

    //
    // MARK:- HTTP Request
    //
    
    /**
        Request to Fanart.TV server

        - parameter url: Request URL
        - parameter completionHandler: The HTTP response will be found here.
    */
    private func processHttpRequest(from url: URL, httpHandler: @escaping HttpRequestCompletionHandler) -> Void
    {
        let request: URLRequest = URLRequest(url: url)

        let data_task: URLSessionDataTask = self.httpSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil
            {
                httpHandler(nil, error)
            }
            else
            {
                if let data = data, let http_response = response as? HTTPURLResponse
                {
                    switch http_response.statusCode
                    {
                        case 200:
                            if let resultado = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                            {
                                httpHandler(resultado, nil)
                            }
                            else
                            {
                                httpHandler(nil, error)
                            }
                        case 400:
                            httpHandler(nil, nil)
                        default:
                            httpHandler(nil, nil)
                    }
                }
            }
        })

        data_task.resume()
    }
}
