//
//  MovieArt.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 19/11/15.
//  Copyright (c) 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// All the images related to a Movie
///

public final class MovieArt
{
    /// Movie's name
    public internal(set) var name: String!
    /// The Movie Database identifier
    public internal(set) var tmdbID: Int!
    /// IMDB identifier
    public internal(set) var imdbID: String!
	/// Logo in HD format
	public internal(set) var logosHD: [FanartImage]?
	/// Movie Logos
	public internal(set) var logos: [FanartImage]?
	/// Disc images
	public internal(set) var discs: [FanartDiscImage]?
	/// Movie Posters
	public internal(set) var posters: [FanartImage]?
	/// Clear Art in HD format
	public internal(set) var clearartsHD: [FanartImage]?
	/// Arts
	public internal(set) var arts: [FanartImage]?
	/// Backgrounds
	public internal(set) var backgrounds: [FanartImage]?
	/// Banners
	public internal(set) var banners: [FanartImage]?
	/// Thumbnails
	public internal(set) var thumbnails: [FanartImage]?
}