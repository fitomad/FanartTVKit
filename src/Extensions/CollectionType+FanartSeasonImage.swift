//
//  CollectionType+FanartSeasonImage.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 18/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

/**
    Methods for collections which contains elements
    of type `FanartSeasonImage`
*/
public extension Collection where Iterator.Element: FanartSeasonImage
{
    /// The diferent seasons
    public var seasonAvailables: [String]?
    {
        return Set(self.map() { $0.season }).sorted()
    }
    
    ///
 	/// All the images in the collection which
    /// *season* is the same as the one defined by user.
    ///
	///	- Parameter language: Filter elements by this value.
	///	- Returns: A new array containing only images from this season
 	///
 	public func filterImagesBySeason(season: String) -> [Iterator.Element]?
 	{
        return self.filter() { $0.season == season }
 	}
}
