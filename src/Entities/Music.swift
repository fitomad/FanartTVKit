//
//  Music.swift
//  FanartTV
//
//  Created by Adolfo Vera Blasco on 21/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Base class for music objects
///
public class Music
{
    /// Artist/Album/Label name
    public internal(set) var name: String!
    /// The Musicbrainz ID
    public internal(set) var musicID: String!
}
