//
//  FanartCDImage.swift
//  FanartTV
//
//  Created by Adolfo Vera Blasco on 21/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Compact Disc printed Image
///
public final class FanartCDImage : FanartBasicImage
{
    /// Disc number if it's a compilation
    public internal(set) var discNumber: Int!
    /// Size...
    public internal(set) var size: Int!
}