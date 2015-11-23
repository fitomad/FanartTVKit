//
//  FanartParser.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 23/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Pase all JSON documents in structures
///
internal final class FanartParser
{
	//
	// MARK:- Internal Methods
	//

	/**
        Parse a JSON document from Fanart.TV to a MovieArt object

        - Parameter results: A JSON document from server
        - Returns: A `MovieArt` object 
    */
    internal func movieFromJSON(results: AnyObject) throws -> MovieArt
    {
        guard let dictionary = results as? [String: AnyObject] else 
        {
            throw FanartClient.FanartError.InvalidData    
        }

        let movieArt: MovieArt = MovieArt()

        // Name
        if let name = dictionary["name"] as? String
        {
            movieArt.name = name
        }

        // The Movie Database ID
        if let 
            tmdb_value = dictionary["tmdb_id"] as? String,
            tmdbID = Int(tmdb_value)
        {
            movieArt.tmdbID = tmdbID
        }
        
        // Internet Movie Database ID 
        if let imdbID = dictionary["imdb_id"] as? String
        {
            movieArt.imdbID = imdbID
        }

        // HD Logos
        if let logosHD = dictionary["hdmovielogo"] as? [[String: AnyObject]] where !logosHD.isEmpty
        {
            movieArt.logosHD = self.parseFanartImageFromArray(logosHD)
        }  

        // Discs
        if let discs = dictionary["hdmovielogo"] as? [[String: AnyObject]] where !discs.isEmpty
        {
            movieArt.discs = self.parseFanartDiscImageFromArray(discs)
        } 

        // Logos
        if let logos = dictionary["movielogo"] as? [[String: AnyObject]] where !logos.isEmpty
        {
            movieArt.logos = self.parseFanartImageFromArray(logos)
        }   

        // Posters
        if let posters = dictionary["movieposter"] as? [[String: AnyObject]] where !posters.isEmpty
        {
            movieArt.posters = self.parseFanartImageFromArray(posters)
        } 

        // HD Clear Art 
        if let clearartHD = dictionary["hdmovieclearart"] as? [[String: AnyObject]] where !clearartHD.isEmpty
        {
            movieArt.clearartsHD = self.parseFanartImageFromArray(clearartHD)
        } 

        //movieart
        if let arts = dictionary["movieart"] as? [[String: AnyObject]] where !arts.isEmpty
        {
            movieArt.arts = self.parseFanartImageFromArray(arts)
        }

        // Backgrounds
        if let backgrounds = dictionary["moviebackground"] as? [[String: AnyObject]] where !backgrounds.isEmpty
        {
            movieArt.backgrounds = self.parseFanartImageFromArray(backgrounds)
        }

        // Banners
        if let banners = dictionary["moviebanner"] as? [[String: AnyObject]] where !banners.isEmpty
        {
            movieArt.banners = self.parseFanartImageFromArray(banners)
        }

        // moviethumb
        if let thumbnails = dictionary["moviethumb"] as? [[String: AnyObject]] where !thumbnails.isEmpty
        {
            movieArt.thumbnails = self.parseFanartImageFromArray(thumbnails)
        }
        
        return movieArt
    }

    /**
        Last movies updated by the server

        - Parameter array: A JSON document from server
        - Returns: An array on `MovieUpdate` object that contains
            last updates
    */
    internal func latestMoviesFromJSON(array: [[String: AnyObject]]) -> [MovieUpdate]
    {
        var updates: [MovieUpdate] = [MovieUpdate]()

        for dictionary in array
        {
            let update: MovieUpdate = MovieUpdate()
            self.parseLatestItemFromJSON(dictionary, inObject: update)

            // The Movie Database ID
            if let 
                tmdb_value = dictionary["tmdb_id"] as? String,
                tmdbID = Int(tmdb_value)
            {
                update.tmdbID = tmdbID
            }
            
            // Internet Movie Database ID 
            if let imdbID = dictionary["imdb_id"] as? String
            {
                update.imdbID = imdbID
            } 

            updates.append(update)
        }

        return updates
    }
    
    /**
        Parse a JSON document from Fanart.TV to a ShowArt class
     
        - Parameter results: A JSON document from server
        - Returns: All the images related to the TV Show
     */
    internal func showFromJSON(results: AnyObject) throws -> ShowArt
    {
        guard let dictionary = results as? [String: AnyObject] else
        {
            throw FanartClient.FanartError.InvalidData
        }
        
        let showArt: ShowArt = ShowArt()
        
        // Name
        if let name = dictionary["name"] as? String
        {
            showArt.showName = name
        }
        
        // The TV Database ID
        if let
            tvdb_value = dictionary["tmdb_id"] as? String,
            tvdbID = Int(tvdb_value)
        {
            showArt.tvdbID = tvdbID
        }
        
        // Clear Logo
        if let logos = dictionary["clearlogo"] as? [[String: AnyObject]] where !logos.isEmpty
        {
            showArt.logos = self.parseFanartImageFromArray(logos)
        }
        
        // HD TV Logo
        if let hdtvLogo = dictionary["hdtvlogo"] as? [[String: AnyObject]] where !hdtvLogo.isEmpty
        {
            showArt.logosHD = self.parseFanartImageFromArray(hdtvLogo)
        }
        
        // Cleart
        if let clearart = dictionary["clearart"] as? [[String: AnyObject]] where !clearart.isEmpty
        {
            showArt.cleararts = self.parseFanartImageFromArray(clearart)
        }
        
        // Backgrounds
        if let backgrounds = dictionary["showbackground"] as? [[String: AnyObject]] where !backgrounds.isEmpty
        {
            showArt.backgrounds = self.parseFanartSeasonImageFromArray(backgrounds)
        }
        
        // Backgrounds
        if let thumbnails = dictionary["tvthumb"] as? [[String: AnyObject]] where !thumbnails.isEmpty
        {
            showArt.thumbnails = self.parseFanartImageFromArray(thumbnails)
        }
        
        // Season Poster
        if let seasonPosters = dictionary["seasonposter"] as? [[String: AnyObject]] where !seasonPosters.isEmpty
        {
            showArt.seasonPosters = self.parseFanartSeasonImageFromArray(seasonPosters)
        }
        
        // Season Thumb
        if let seasonThumb = dictionary["seasonthumb"] as? [[String: AnyObject]] where !seasonThumb.isEmpty
        {
            showArt.seasonThumbnails = self.parseFanartSeasonImageFromArray(seasonThumb)
        }
        
        // Clearart HD
        if let clearartHD = dictionary["hdclearart"] as? [[String: AnyObject]] where !clearartHD.isEmpty
        {
            showArt.clearartHD = self.parseFanartImageFromArray(clearartHD)
        }
        
        // Banners
        if let banners = dictionary["tvbanner"] as? [[String: AnyObject]] where !banners.isEmpty
        {
            showArt.banners = self.parseFanartImageFromArray(banners)
        }
        
        // Banners
        if let characters = dictionary["characterart"] as? [[String: AnyObject]] where !characters.isEmpty
        {
            showArt.characters = self.parseFanartImageFromArray(characters)
        }
        
        // Banners
        if let posters = dictionary["tvposter"] as? [[String: AnyObject]] where !posters.isEmpty
        {
            showArt.posters = self.parseFanartImageFromArray(posters)
        }
        
        // Banners
        if let seasonBanner = dictionary["seasonbanner"] as? [[String: AnyObject]] where !seasonBanner.isEmpty
        {
            showArt.seasonBanners = self.parseFanartSeasonImageFromArray(seasonBanner)
        }
        
        return showArt
    }

    
    /**
        Updates for TV Shows 
     
        - Parameter array: Shows updated by Fanart.TV
        - Returns: An array with all shows updated
     */
    internal func latestShowsFromJSON(array: [[String: AnyObject]]) -> [ShowUpdate]
    {
        var updates: [ShowUpdate] = [ShowUpdate]()
        
        for dictionary in array
        {
            let update: ShowUpdate = ShowUpdate()
            self.parseLatestItemFromJSON(dictionary, inObject: update)
            
            // The Movie Database ID
            if let
                id_value = dictionary["id"] as? String,
                itemID = Int(id_value)
            {
                update.itemID = itemID
            }
            
            updates.append(update)
        }
        
        return updates
    }

    /**
        Parse a JSON document from Fanart.TV to an Artist class
     
        - Parameter results: A JSON document from server
        - Returns: All images associated with the artist
     */
    internal func artistFromJSON(results: AnyObject) throws -> MusicArtistArt
    {
        guard let dictionary = results as? [String: AnyObject] else
        {
            throw FanartClient.FanartError.InvalidData
        }
        
        let musicArtistArt: MusicArtistArt = MusicArtistArt()
        
        // Name
        if let name = dictionary["name"] as? String
        {
            musicArtistArt.name = name
        }
        
        // The Musicbrainz ID
        if let mbid_value = dictionary["mbid_id"] as? String
        {
            musicArtistArt.musicID = mbid_value
        }
        
        // Backgrounds
        if let backgrounds = dictionary["artistbackground"] as? [[String: AnyObject]] where !backgrounds.isEmpty
        {
            musicArtistArt.backgrounds = self.parseFanartBasicImageFromArray(backgrounds)
        }
        
        // Thumbnails
        if let thumbnails = dictionary["artistthumb"] as? [[String: AnyObject]] where !thumbnails.isEmpty
        {
            musicArtistArt.thumbnails = self.parseFanartBasicImageFromArray(thumbnails)
        }
        
        // Logos
        if let logos = dictionary["musiclogo"] as? [[String: AnyObject]] where !logos.isEmpty
        {
            musicArtistArt.logos = self.parseFanartBasicImageFromArray(logos)
        }
        
        // Logos in HD format
        if let logosHD = dictionary["hdmusiclogo"] as? [[String: AnyObject]] where !logosHD.isEmpty
        {
            musicArtistArt.logosHD = self.parseFanartBasicImageFromArray(logosHD)
        }
        
        // Banners
        if let banners = dictionary["musicbanner"] as? [[String: AnyObject]] where !banners.isEmpty
        {
            musicArtistArt.banners = self.parseFanartBasicImageFromArray(banners)
        }
        
        // Albums
        if let albums = dictionary["albums"] as? [String: AnyObject] where !albums.isEmpty
        {
            musicArtistArt.albums = self.parseAlbumsFromDictionary(albums)
        }
        
        return musicArtistArt
    }

    /**
        Parse a JSON document from Fanart.TV to a Music Label class
     
        - Parameter results: JSON document from server
        - Returns: All images related to this Music Label
     */
    internal func labelFromJSON(results: AnyObject) throws -> MusicLabelArt
    {
        guard let dictionary = results as? [String: AnyObject] else
        {
            throw FanartClient.FanartError.InvalidData
        }
        
        let musicLabelArt: MusicLabelArt = MusicLabelArt()
        
        // Name
        if let name = dictionary["name"] as? String
        {
            musicLabelArt.name = name
        }
        
        // The Musicbrainz ID
        if let id_value = dictionary["id"] as? String
        {
            musicLabelArt.musicID = id_value
        }
        
        // Labels
        if let labels = dictionary["musiclabel"] as? [[String: AnyObject]] where !labels.isEmpty
        {
            musicLabelArt.labels = self.parseFanartColorImageFromArray(labels)
        }
        
        return musicLabelArt
    }

    /**
        Parse a JSON document from Fanart.TV to a Music Album class
     
        - Parameter results: JSON document from server
        - Returns: All images related to the album
    */
    internal func albumFromJSON(results: AnyObject) throws -> MusicAlbumArt
    {
        guard let dictionary = results as? [String: AnyObject] else
        {
            throw FanartClient.FanartError.InvalidData
        }
        
        let musicAlbumArt: MusicAlbumArt = MusicAlbumArt()
        
        // Name
        if let name = dictionary["name"] as? String
        {
            musicAlbumArt.name = name
        }
        
        // The Musicbrainz ID
        if let mbid_value = dictionary["mbid_id"] as? String
        {
            musicAlbumArt.musicID = mbid_value
        }

        // The albums
        if let albums = dictionary["albums"] as? [String: AnyObject] where !albums.isEmpty
        {
            musicAlbumArt.albums = self.parseAlbumsFromDictionary(albums)
        }

        return musicAlbumArt
    }

	//
	// MARK:- Private Methods
	//

	/**
        Put JSON info in the object passed as reference in the method
        argument

        - Parameter dictionary: A single basic image JSON representation
        - Parameter inObject: The object that will *store* the JSON data
    */
    private func parseFanartBasicImageFromJSON(dictionary: [String: AnyObject], inObject object: FanartBasicImage) -> Void
    {
        if let
            id_value = dictionary["id"] as? String,
            imageID = Int(id_value)
        {
            object.imageID = imageID
        }
        
        if let
            resource = dictionary["url"] as? String,
            url = NSURL(string: resource)
        {
            object.url = url
        }
        
        if let
            likes_value = dictionary["likes"] as? String,
            likes = Int(likes_value)
        {
            object.likes = likes
        }
    }

    /**
        Convert a JSON array to a collection of `FanartBasicImage`
        objects.

        - Parameter array: A collection of `FanartBasicImage` classes or subclasses
        - Returns: An array of Basic Images
    */
    private func parseFanartBasicImageFromArray(array: [[String: AnyObject]]) -> [FanartBasicImage]
    {
        var images: [FanartBasicImage] = [FanartBasicImage]()

        for dictionary in array
        {
            let image: FanartBasicImage = FanartBasicImage()
            self.parseFanartBasicImageFromJSON(dictionary, inObject: image)

            images.append(image)
        }
        
        return images
    }

    /**
        Parsing a JSON array that corresponds to a CD's image

        - Parameter dictionary: A *single basic CD image* JSON representation
        - Returns: A `FanartCDImage` object with a CD image information
    */
    private func parseFanartCDImageFromJSON(dictionary: [String: AnyObject]) -> FanartCDImage
    {
        let image: FanartCDImage = FanartCDImage()

        self.parseFanartBasicImageFromJSON(dictionary, inObject: image)

        if let
            disc_value = dictionary["disc_number"] as? String,
            disc_number = Int(disc_value)
        {
            image.discNumber = disc_number
        }
        
        if let
            size_value = dictionary["size"] as? String,
            size = Int(size_value)
        {
            image.size = size
        }

        return image
    }

    /**
        Convert a JSON array to a collection of `FanartCDImage` objects.

        - Parameter array: A JSON array that contains information about CD images
        - Returns: An array of `FanartCDImage` objects
    */
    private func parseFanartCDImageFromArray(array: [[String: AnyObject]]) -> [FanartCDImage]
    {
        var images: [FanartCDImage] = [FanartCDImage]()

        for dictionary in array
        {
            let image: FanartCDImage = self.parseFanartCDImageFromJSON(dictionary)

            images.append(image)
        }
        
        return images
    }

    /**
        Parsing a JSON array that corresponds to a Label Color Image

        - Parameter dictionary: A single Label Color image JSON representation
        - Returns: A `FanartColorImage` with a Label *Colour* image information
    */
    private func parseFanartColorImageFromJSON(dictionary: [String: AnyObject]) -> FanartColorImage
    {
        let image: FanartColorImage = FanartColorImage()

        self.parseFanartBasicImageFromJSON(dictionary, inObject: image)

        if let color = dictionary["colour"] as? String
        {
            image.colorName = color
        }

        return image
    }

    /**
        Convert a JSON array to a collection of `FanartColorImage` objects.

        - Parameter array: A JSON array the contains information about Label *Colour* images
        - Returns: An array on `FanartColorImage` objects
    */
    private func parseFanartColorImageFromArray(array: [[String: AnyObject]]) -> [FanartColorImage]
    {
        var images: [FanartColorImage] = [FanartColorImage]()

        for dictionary in array
        {
            let image: FanartColorImage = self.parseFanartColorImageFromJSON(dictionary)

            images.append(image)
        }
        
        return images
    }

    /**
        Convert a JSON array to a collection of `AlbumArt` objects.

        - Parameter array: A JSON array the contains information about Music Albums
        - Returns: An array on `AlbumArt` objects
    */
    private func parseAlbumsFromDictionary(dictionary: [String: AnyObject]) -> [AlbumArt]
    {
        var albums: [AlbumArt] = [AlbumArt]()

        for key in dictionary.keys
        {
            let album_data: [String: AnyObject] = dictionary[key] as! [String: AnyObject]
            
            let album: AlbumArt = self.parseAlbumFromJSON(album_data)
            album.albumID = key
            
            albums.append(album)
        }

        return albums
    }

    /**
        Parsing a JSON array that corresponds to a Album images, usually 
        albu's cover image and the CD art image

        - Parameter dictionary: A single Album JSON representation
        - Returns: A `AlbumArt` with a Album images information
    */
    private func parseAlbumFromJSON(dictionary: [String: AnyObject]) -> AlbumArt
    {
        let album: AlbumArt = AlbumArt()

        if let cdart = dictionary["cdart"] as? [[String: AnyObject]] where !cdart.isEmpty
        {
            album.artCD = self.parseFanartCDImageFromArray(cdart)
        } 

        if let covers = dictionary["albumcover"] as? [[String: AnyObject]] where !covers.isEmpty
        {
            album.covers = self.parseFanartBasicImageFromArray(covers)
        } 

        return album
    }

    /**
        JSON representing a basic image

        - Parameter array: A JSON array the contains information about images
        - Returns: An array on `FanartImage` objects
    */
    private func parseFanartImageFromArray(array: [[String: AnyObject]]) -> [FanartImage]
    {
        var images: [FanartImage] = [FanartImage]()

        for dictionary in array
        {
            let image: FanartImage = FanartImage()
            self.parseFanartImageFromJSON(dictionary)
            images.append(image)
        }
        
        return images
    }

    /**
        Parsing a JSON array that corresponds to a basic image

        - Parameter dictionary: A single basic image representation
        - Returns: A `FanartImage` with image information
    */
    private func parseFanartImageFromJSON(dictionary: [String: AnyObject]) -> FanartImage
    {
        let fanartImage: FanartImage = FanartImage()
        self.parseFanartImageFromJSON(dictionary, inObject: fanartImage)

        return fanartImage
    }
    
    /**
        Parsing a JSON array that corresponds to a basic image and 
        store it in the object that is passed by reference as argument.

        - Parameter dictionary: A single Album JSON representation
        - Parameter inObject: Here we store the JSON information
    */
    private func parseFanartImageFromJSON(dictionary: [String: AnyObject], inObject object: FanartImage) -> Void
    {
        self.parseFanartBasicImageFromJSON(dictionary, inObject: object)

        if let lang = dictionary["lang"] as? String
        {
            object.language = lang
        }
    }

    /**
        JSON representing a Movie Disc image

        - Parameter array: A JSON array the contains information about the image
        - Returns: An array on `FanartDiscImage` objects
    */
    private func parseFanartDiscImageFromArray(array: [[String: AnyObject]]) -> [FanartDiscImage]
    {
        var images: [FanartDiscImage] = [FanartDiscImage]()
        
        for dictionary in array
        {
            let image: FanartDiscImage = self.parseFanartDiscImageFromJSON(dictionary)
            images.append(image)
        }
        
        return images
    }
    
    /**
        Parsing a JSON array that corresponds to a Movie Disc

        - Parameter dictionary: A single movie disc image representation
        - Returns: A `FanartDiscImage` with image information
    */
    private func parseFanartDiscImageFromJSON(dictionary: [String: AnyObject]) -> FanartDiscImage
    {
        let discImage: FanartDiscImage = FanartDiscImage()
        self.parseFanartImageFromJSON(dictionary, inObject: discImage)
        
        if let 
            disc_value = dictionary["disc"] as? String,
            disc = Int(disc_value)
        {
            discImage.discNumber = disc
        }

        if let disc_type = dictionary["disc_type"] as? String
        {
            discImage.discType = disc_type
        }

        return discImage
    }
    
    /**
        JSON representing a collection of TV shows images categorized by season

        - Parameter array: A JSON array that contains information about TV Shows seasons
        - Returns: An array on `FanartSeasonImage` objects
    */
    private func parseFanartSeasonImageFromArray(array: [[String: AnyObject]]) -> [FanartSeasonImage]
    {
        var images: [FanartSeasonImage] = [FanartSeasonImage]()
        
        for dictionary in array
        {
            let image: FanartSeasonImage = self.parseFanartSeasonImageFromJSON(dictionary)
            images.append(image)
        }
        
        return images
    }

    /**
        JSON representing a TV Shows image related to a season

        - Parameter array: A JSON array that contains information about the image
        - Returns: An array on `FanartSeasonImage` objects
    */
    private func parseFanartSeasonImageFromJSON(dictionary: [String: AnyObject]) -> FanartSeasonImage
    {
        let seasonImage: FanartSeasonImage = FanartSeasonImage()
        self.parseFanartImageFromJSON(dictionary, inObject: seasonImage)

        if let season = dictionary["season"] as? String
        {
            seasonImage.season = season
        }

        return seasonImage
    }

    /**
        Basic representation of the Update info sent by the server. 
        Data will be stored in the object passed by reference as argument.

        - Parameter array: Updates by Fanart.TV
        - Parameter inObject: Here we store the JSON data
    */
    private func parseLatestItemFromJSON(dictionary: [String: AnyObject], inObject object: Update) -> Void
    {
        // Name
        if let name = dictionary["name"] as? String
        {
            object.name = name
        }

        // New Images
        if let 
            new_images_value = dictionary["new_images"] as? String,
            newImages = Int(new_images_value)
        {
            object.newImages = newImages
        }

        // Total Images
        if let 
            total_images_value = dictionary["total_images"] as? String,
            totalImages = Int(total_images_value)
        {
            object.totalImages = totalImages
        }
    }
}