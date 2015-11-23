//
//  MutableCollectionType+FanartSeasonImage.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 23/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Methods for collections which contains elements
/// of type `FanartSeasonImage`
///
public extension MutableCollectionType where Generator.Element: FanartSeasonImage
{   
    ///
 	/// All the images in the collection sorted by *season*
    ///
	///	- Returns: A new array sorted by season
 	///
 	public func sortBySeason() -> [Generator.Element]?
    {
        return self.sort() { $0.season < $1.season }
    }

    ///
    /// Performs a sort operation over the own object
    ///
    public mutating func sortInPlaceBySeason() -> Void
    {
        self = self.sortBySeason() as! Self
    }
}