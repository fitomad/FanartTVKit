//
//  FanartBasicImage.swift
//  FanartTV
//
//  Created by Adolfo Vera Blasco on 21/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Base class for all Fanart.TV images
///
public class FanartBasicImage : Equatable
{
    /// Image identifier
    public internal(set) var imageID: Int!
    /// The image URL
    public internal(set) var url: NSURL!
    /// How much people like this image
    public internal(set) var likes: Int!
}

// MARK: Custom `==` operator implementation

///
/// Both objects are equal if their `imageID` property is the same
///
public func ==(lhs: FanartBasicImage, rhs: FanartBasicImage) -> Bool 
{
    return lhs.imageID == rhs.imageID
}