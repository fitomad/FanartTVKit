//
//  FanartDiscImage.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 19/11/15.
//  Copyright (c) 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Video/DVD/BlueRay disc image
///
public final class FanartDiscImage : FanartImage
{
	/// Disc number if there are more than one
	public internal(set) var discNumber: Int!
	/// Disc type
	public internal(set) var discType: String!
}