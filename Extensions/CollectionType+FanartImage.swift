//
//  CollectionType+FanartImage.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 18/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

/**
    Methods for collections which contains elements
    of type `FanartImage`
*/
public extension CollectionType where Generator.Element: FanartImage
{
    /// The diferent languages
    public var languagesAvailables: [String]?
    {
        return Set(self.map() { $0.language }).sort()
    }
    
    ///
 	/// All the images in the collection marked with
    /// the language defined by user.
    ///
	///	- Parameter language: Filter elements by this value.
	///	- Returns: A new array containing only
 	///
 	public func filterImagesByLanguage(language: String) -> [Generator.Element]?
 	{
        return self.filter() { $0.language == language }
 	}
}