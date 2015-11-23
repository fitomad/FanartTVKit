//
//  FanartClient.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 18/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import UIKit
import Foundation

// MARK:- Completion Handlers

///
/// Art related to an unique movie will be find here...
///
public typealias MovieCompletionHandler = (movie: MovieArt?, error: NSError?) -> (Void)

///
/// Latest movies updated will be find here...
///
public typealias LatestMoviesCompletionHandler = (movies: [MovieUpdate]?, error: NSError?) -> (Void)

///
/// Art related to an unique TV Show will be find here...
///
public typealias ShowCompletionHandler = (show: ShowArt?, error: NSError?) -> (Void)

///
/// Latest TV Shows updated will be find here...
///
public typealias LatestShowsCompletionHandler = (shows: [ShowUpdate]?, error: NSError?) -> (Void)

///
/// Art related to an unique music artist will be find here...
///
public typealias ArtistCompletionHandler = (artist: MusicArtistArt?, error: NSError?) -> (Void)

///
/// Art related to an unique music label will be find here...
///
public typealias LabelCompletionHandler = (label: MusicLabelArt?, error: NSError?) -> (Void)

///
/// Art related to an unique music album will be find here...
///
public typealias AlbumCompletionHandler = (album: MusicAlbumArt?, error: NSError?) -> (Void)

///
/// Art related to an unique music label will be find here...
///
public typealias LatestArtistsCompletionHandler = (artists: [MusicUpdate]?, error: NSError?) -> Void

///
/// An image requested to Fanart.TV will be find here...
///
public typealias ImageRequestCompletionHandler = (image: UIImage?) -> (Void)

///
/// All API request will be *returned* here
///
private typealias HttpRequestCompletionHandler = (results: AnyObject?, error: NSError?) -> (Void)

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
    /**
        Availables exceptions that you could
        find will process an user request.

        Nowadays there is only one kind of error due to the problems found 
        trying to use Error Handling with the NSURLSession working model. 
        Those method signatures does not include the `throw` keyword, 
        making impossible throws an exception.

        More info at the **Error Handling** section on the 
        [Using Swift with Cocoa and objective-C](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/AdoptingCocoaDesignPatterns.html#//apple_ref/doc/uid/TP40014216-CH7-ID6)
         book

        The *error* capture is

        - InvalidData. JSON is not in the apropiated format
    */
    internal enum FanartError : ErrorType
    {
        /// Data not valid
        case InvalidData
    }

    /// Singleton instance
    public static let sharedInstance: FanartClient = FanartClient()
    
    /// Your Fanart.TV  project/personal api key
    private let apiKey: String = "32506e12c111300375a3444dbfb5e6c4"
    /// All the api request starts with this.
    private let baseURL: String = "https://webservice.fanart.tv/v3"

    /// The API client HTTP session
    private var httpSession: NSURLSession!
    /// API client HTTP configuration
    private var httpConfiguration: NSURLSessionConfiguration!

    /// The object dedicated to convert from JSON data
    /// obtained from Fanart.TV to out own data structures
    private var parser: FanartParser!
    
    /**
        Initialize and set up the network connection
    */
    private init()
    {
        self.parser = FanartParser()

        self.httpConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.httpConfiguration.HTTPMaximumConnectionsPerHost = 10

        let http_queue: NSOperationQueue = NSOperationQueue()
        http_queue.maxConcurrentOperationCount = 10

        self.httpSession = NSURLSession(configuration:self.httpConfiguration,
                                             delegate:nil,
                                        delegateQueue:http_queue)
    }
    
    //
    // MARK:- Movies
    //
    
    /**
        Request all resources for a movie

        - Parameter movieID: A tmdb_id or imdb_id valid identificator
        - Parameter completionHandler: Closure in which put the results
    */
    public func fanartForMovie(movieID: AnyObject, completionHandler: MovieCompletionHandler) -> Void
    {
        guard movieID is Int || movieID is String else
        {
            return
        }
        
        let web_resource: String = "\(self.baseURL)/movies/\(movieID)?api_key=\(self.apiKey)"
        let url: NSURL = NSURL(string: web_resource)!

        self.processHttpRequestForURL(url, httpHandler: { (results: AnyObject?, error: NSError?) -> (Void) in
            // Parsing JSON to Movie
            guard let results = results else
            {
                completionHandler(movie: nil, error: error)
                return
            }
            
            do
            {
                // Parse JSON to Movie
                let movieArt: MovieArt = try self.parser.movieFromJSON(results)
                completionHandler(movie: movieArt, error: nil)
            }   
            catch let parsingError as NSError
            {
                completionHandler(movie: nil, error: parsingError)
            } 
        })
    }
    
    /**
        Last movies affected by changes from a date

        - Parameter date: Movies updated from this date to Now
        - Parameter completionHandler: Data response
    */
    public func latestMoviesFromDate(date: NSTimeInterval, completionHandler: LatestMoviesCompletionHandler) -> Void
    {
        let timestamp: Int = Int(date)
        let web_resource: String = "\(self.baseURL)/movies/latest?api_key=\(self.apiKey)&date=\(timestamp)"
        let url: NSURL = NSURL(string: web_resource)!

        self.processHttpRequestForURL(url, httpHandler: { (results: AnyObject?, error: NSError?) -> (Void) in
            // Parse JSON to Movie
            guard let results = results, datos = results as? [[String: AnyObject]] else
            {
                completionHandler(movies: nil, error: error)
                return
            }

            let updates: [MovieUpdate] = self.parser.latestMoviesFromJSON(datos)
            completionHandler(movies: updates, error: nil)
        })
    }
    
    //
    // MARK:- Shows
    //
    
    /**
        All images availables for a TV Show
    
        - Parameter showID: The TVDB identifier for the show
        - Parameter completionHandler: Here we return the results
    */
    public func fanartForShow(showID: Int, completionHandler: ShowCompletionHandler) -> Void
    {
        let web_resource: String = "\(self.baseURL)/tv/\(showID)?api_key=\(self.apiKey)"
        let url: NSURL = NSURL(string: web_resource)!
        
        self.processHttpRequestForURL(url, httpHandler: { (results: AnyObject?, error: NSError?) -> (Void) in
            // Parse JSON to TV Show
            guard let results = results, datos = results as? [String: AnyObject] else
            {
                completionHandler(show: nil, error: error)
                return
            }
            
            do
            {
                // Parse JSON to Show
                let showArt: ShowArt = try self.parser.showFromJSON(datos)
                completionHandler(show: showArt, error: nil)
            }
            catch let parsingError as NSError
            {
                completionHandler(show: nil, error: parsingError)
            }
        })
    }
    
    /**
        Last shows affected by changes since the date
     
        - Parameter date: Movies updated from this date to Now
        - Parameter completionHandler:
     */
    public func latestShowsFromDate(date: NSTimeInterval, completionHandler: LatestShowsCompletionHandler) -> Void
    {
        let timestamp: Int = Int(date)
        let web_resource: String = "\(self.baseURL)/tv/latest?api_key=\(self.apiKey)&date=\(timestamp)"
        let url: NSURL = NSURL(string: web_resource)!
        
        self.processHttpRequestForURL(url, httpHandler: { (results: AnyObject?, error: NSError?) -> (Void) in
            // Parse JSON to Show
            guard let results = results, datos = results as? [[String: AnyObject]] else
            {
                completionHandler(shows: nil, error: error)
                return
            }
            
            let updates: [ShowUpdate] = self.parser.latestShowsFromJSON(datos)
            completionHandler(shows: updates, error: nil)
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
    public func fanartForMusicArtist(artisID: String, completionHandler: ArtistCompletionHandler) -> Void
    {
        let web_resource: String = "\(self.baseURL)/music/\(artisID)?api_key=\(self.apiKey)"
        let url: NSURL = NSURL(string: web_resource)!
        
        self.processHttpRequestForURL(url, httpHandler: { (results: AnyObject?, error: NSError?) -> (Void) in
            // Parse JSON to Music Artist
            guard let results = results, datos = results as? [String: AnyObject] else
            {
                completionHandler(artist: nil, error: error)
                return
            }
            
            do
            {
                let musicArtistArt: MusicArtistArt = try self.parser.artistFromJSON(datos)
                completionHandler(artist: musicArtistArt, error: nil)
            }
            catch let parsingError as NSError
            {
                completionHandler(artist: nil, error: parsingError)
            }
        })
    }

    /**
        All images availables for this music label
    
        - Parameter labelID: The Musicbrainz identifier for the label
        - Parameter completionHandler: Here we return the results
    */
    public func fanartForMusicLabel(labelID: String, completionHandler: LabelCompletionHandler) -> Void
    {
        let web_resource: String = "\(self.baseURL)/labels/\(labelID)?api_key=\(self.apiKey)"
        let url: NSURL = NSURL(string: web_resource)!
        
        self.processHttpRequestForURL(url, httpHandler: { (results: AnyObject?, error: NSError?) -> (Void) in
            // Parse JSON to Music Label
            guard let results = results, datos = results as? [String: AnyObject] else
            {
                completionHandler(label: nil, error: error)
                return
            }
            
            do
            {
                let musicLabelArt: MusicLabelArt = try self.parser.labelFromJSON(datos)
                completionHandler(label: musicLabelArt, error: nil)
            }
            catch let parsingError as NSError
            {
                completionHandler(label: nil, error: parsingError)
            }
        })
    }

    /**
        All images availables for this music album
    
        - Parameter albumID: The Musicbrainz identifier for the album
        - Parameter completionHandler: Here we return the results
    */
    public func fanartForMusicAlbum(albumID: String, completionHandler: AlbumCompletionHandler) -> Void
    {
        let web_resource: String = "\(self.baseURL)/albums/\(albumID)?api_key=\(self.apiKey)"
        let url: NSURL = NSURL(string: web_resource)!
        
        self.processHttpRequestForURL(url, httpHandler: { (results: AnyObject?, error: NSError?) -> (Void) in
            // Parse JSON to Music Album
            guard let results = results, datos = results as? [String: AnyObject] else
            {
                completionHandler(album: nil, error: error)
                return
            }
            
            do
            {
                let musicAlbumArt: MusicAlbumArt = try self.parser.albumFromJSON(datos)
                completionHandler(album: musicAlbumArt, error: nil)
            }
            catch let parsingError as NSError
            {
                completionHandler(album: nil, error: parsingError)
            }
        })
    }

    /**
        Last music artist affected by changes since the date
     
        - Parameter date: Music Artist updated from this date to Now
        - Parameter completionHandler: The updates will be passed here
     */
    public func latestArtistsFromDate(date: NSTimeInterval, completionHandler: LatestArtistsCompletionHandler) -> Void
    {
        let timestamp: Int = Int(date)
        let web_resource: String = "\(self.baseURL)/music/latest?api_key=\(self.apiKey)&date=\(timestamp)"
        let url: NSURL = NSURL(string: web_resource)!
        
        self.processHttpRequestForURL(url, httpHandler: { (results: AnyObject?, error: NSError?) -> (Void) in
            // Parse JSON to Artists
            guard let results = results, datos = results as? [[String: AnyObject]] else
            {
                completionHandler(artists: nil, error: error)
                return
            }
            
            // Call the `latestShowsFromJSON` cause the resultant 
            // structure is the same. Remember that `MusicUpdate`
            // is just an alias for `ShowUpdate` class
            let updates: [MusicUpdate] = self.parser.latestShowsFromJSON(datos)
            completionHandler(artists: updates, error: nil)
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
    public func downloadImageFromURL(url: NSURL, completionHandler: ImageRequestCompletionHandler) -> Void
    {
        let request: NSURLRequest = NSURLRequest(URL: url)

        let data_task: NSURLSessionDataTask = self.httpSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let
                data = data,
                http_response = response as? NSHTTPURLResponse
            where http_response.statusCode == 200
            {
                if let imagen = UIImage(data: data) 
                {
                    completionHandler(image: imagen)
                }
                else 
                {
                    completionHandler(image: nil)
                }
            }
            else 
            {
                completionHandler(image: nil)
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
    private func processHttpRequestForURL(url: NSURL, httpHandler: HttpRequestCompletionHandler) -> Void
    {
        let request: NSURLRequest = NSURLRequest(URL: url)

        let data_task: NSURLSessionDataTask = self.httpSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil
            {
                httpHandler(results: nil, error: error)
            }
            else
            {
                if let
                    data = data,
                    http_response = response as? NSHTTPURLResponse
                {
                    switch http_response.statusCode
                    {
                        case 200:
                            if let resultado = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                            {
                                httpHandler(results: resultado, error: nil)
                            }
                            else
                            {
                                httpHandler(results: nil, error: error)
                            }
                        case 400:
                            httpHandler(results: nil, error: nil)
                        default:
                            httpHandler(results: nil, error: nil)
                    }
                }
            }
        })

        data_task.resume()
    }
}
