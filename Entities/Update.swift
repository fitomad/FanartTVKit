//
//  Update.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 18/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Base class for Music/Movies/Shows updates
///
public class Update
{
	/// The name
	public internal(set) var name: String!
	/// Number of new images added
	public internal(set) var newImages: Int!
	/// Total images availables for this item
	public internal(set) var totalImages: Int!
}