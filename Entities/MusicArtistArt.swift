//
//  MusicArtistArt.swift
//  FanartTV
//
//  Created by Adolfo Vera Blasco on 21/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Music Artist images
///
public final class MusicArtistArt : Music
{
    /// Artist backgrounds
    public internal(set) var backgrounds: [FanartBasicImage]?
    /// Little images
    public internal(set) var thumbnails: [FanartBasicImage]?
    /// Logos
    public internal(set) var logos: [FanartBasicImage]?
    /// Logos in HD format
    public internal(set) var logosHD: [FanartBasicImage]?
    /// Banners
    public internal(set) var banners: [FanartBasicImage]?
    /// Artist's albums images
    public internal(set) var albums: [AlbumArt]?
}
