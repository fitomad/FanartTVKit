//
//  NSDate+UnixTimeStamp.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 18/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

extension NSDate
{
	/**
        An easy way to obtain Unix Timestamp from a date.
		
        - Parameters:
			- year: Four digits representing date's year
			- month: One or two digits representing date's month
			- day: One or two digits representing date's day
		- Returns: The timestamp if the type method has been able to calculate it
	*/
	class func unixTimeStampSinceYear(year: Int, month: Int, day: Int) -> NSTimeInterval?
    {
        let components: NSDateComponents = NSDateComponents()
        components.calendar = NSCalendar.currentCalendar()
        
        components.year = year 
        components.month = month
        components.day = day 
        
        if let fecha = components.date
        {
            return fecha.timeIntervalSince1970
        }
        
        return nil
    }
}