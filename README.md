# FanartTVKit
![License Mit](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat-square) ![Xcode 9.0](https://img.shields.io/badge/Xcode-9.0-red.svg?style=flat-square) ![iOS 11](https://img.shields.io/badge/iOS-11-red.svg?style=flat-square) ![macOS 10.13](https://img.shields.io/badge/macOS-10.13-red.svg?style=flat-square) ![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat-square)

Fanart.TV API written in Swift. This new version has been fully rewritten in **Swift 4.0** and redesigned to acomplish the new *API design guideline* conventions also.

The [Fanart.TV](http://fanart.tv) is the best place to find images related to movies, shows or music. First of all you have to obtain an [API Key](https://fanart.tv/get-an-api-key/). Read [API documentation](http://docs.fanarttv.apiary.io/#) it's a really good idea.

## Usage
The API's entry is the `FanartClient`class that contains methods to ask for Movies, TV Shows and Music related images. FanartTVKit provides covers the whole Fanart.TV operations

* Movies
    * Movie
    * Latests Movies
* TV
    * Show
    * Latests Shows
* Music
    * Artist
    * Album
    * Label
    * Latests

## Movies changes

FanartClient has two new methods to request movies' art, depending on movie identifier source, TMDB or IMDB

```swift
FanartClient.shared.movie(tmdb: Int, completionHandler: @escaping FanartCompletionHandler<FanartResult<MovieArt>>) -> Void

or

FanartClient.shared.movie(imdb: String, completionHandler: @escaping FanartCompletionHandler<FanartResult<MovieArt>>) -> Void 
```

## Code Examples

Inside Test folder you will find a XCTest file which contains examples for all API methods.

### TV Shows
In lines below you will see an example of a request for the **Suits** TV Show

```swift
// Manhattan Love Story
let showID: Int = 281624

FanartClient.shared.show(identifier: showID) { (result: FanartResult<ShowArt>) -> (Void) in
    switch result
    {
        case let .error(reason):
            print("err @ \(#function) -> \(reason)")
        
        case let .success(show):
            print("# \(show.showName)")
    }
}
```

### Movies
Now we are going to request fanart for one of my favorites movies... [The Goonies](http://www.imdb.com/title/tt0089218/)

```Swift
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
}
```

### Music

And finally an example requesting images related to [Depeche Mode](http://www.depechemode.com)

```swift
// Depeche Mode
let artistID: String = "8538e728-ca0b-4321-b7e5-cff6565dd4c0"
        
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
}
```

## Contact
If you have any question or suggestion feel free to contact me at [@fitomad](https://twitter.com/fitomad) on Twitter.

## About
This framework has been written with `Swift 4` in mind using Xcode 9. [Postman](https://www.getpostman.com) has been a *very best friend* during FanartTVKit development process
