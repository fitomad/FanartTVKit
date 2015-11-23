//
//  ShowArt.swift
//  FanartTV
//
//  Created by Adolfo Vera Blasco on 19/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// All the images related to a TV Show
///
public final class ShowArt
{
    /// The Show ID
    public internal(set) var showID: Int!
    /// Show name
    public internal(set) var showName: String!
    /// The TVDB shows ID
    public internal(set) var tvdbID: Int!
    /// Shows Logos
    public internal(set) var logos: [FanartImage]?
    /// Show logo in HD format
    public internal(set) var logosHD: [FanartImage]?
    /// Clear Art
    public internal(set) var cleararts: [FanartImage]?
    /// Show Backgrounds
    public internal(set) var backgrounds: [FanartSeasonImage]?
    /// Show thumbnails
    public internal(set) var thumbnails: [FanartImage]?
    /// Show posters
    public internal(set) var posters: [FanartImage]?
    /// Show poster associated to a season
    public internal(set) var seasonPosters: [FanartSeasonImage]?
    /// Show thumbnail associated to a season
    public internal(set) var seasonThumbnails: [FanartSeasonImage]?
    /// Clear Art in HD formar
    public internal(set) var clearartHD: [FanartImage]?
    /// Show banners
    public internal(set) var banners: [FanartImage]?
    /// Show actors
    public internal(set) var characters: [FanartImage]?
    /// Show banners associated to a season
    public internal(set) var seasonBanners: [FanartSeasonImage]?
}