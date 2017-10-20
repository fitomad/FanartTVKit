//
//  MovieUpdate.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 19/11/15.
//  Copyright (c) 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

///
/// Movie updated by Fanart.TV
///
public final class MovieUpdate : Update
{
	///
	public internal(set) var tmdbID: Int!
	///
	public internal(set) var imdbID: String!
}