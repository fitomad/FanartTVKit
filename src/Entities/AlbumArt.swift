//
//  AlbumArt.swift
//  FanartTV
//
//  Created by Adolfo Vera Blasco on 21/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// All the images related to a Music Album
///
public final class AlbumArt
{
    /// Album Musicbrainz identifier
    public internal(set) var albumID: String!
    /// Cover images
    public internal(set) var covers: [FanartBasicImage]?
    /// Compact Disc print image
    public internal(set) var artCD: [FanartCDImage]?
}
