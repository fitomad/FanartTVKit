//
//  FanartSeasonImage.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 19/11/15.
//  Copyright (c) 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// An image related to a unique TV Show season
///
public final class FanartSeasonImage : FanartImage
{
	/// Season
	public internal(set) var season: String!

	/// Image could be applied to all seasons
	public var validForAllSeasons: Bool
	{
		return self.season == "all"
	}
}