//
//  FanartColorImage.swift
//  FanartTV
//
//  Created by Adolfo Vera Blasco on 21/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

import UIKit
import Foundation

///
/// *Coloured* image related to a Music Label
///
public final class FanartColorImage : FanartBasicImage
{
    /// Color name
    public internal(set) var colorName: String!
    
    /// Color associated with the color name
    public var color: UIColor?
    {
    	switch self.colorName
    	{
    		case "white":
    			return UIColor.whiteColor()
    		case "black":
    			return UIColor.blackColor()
    		case "gray":
    			return UIColor.grayColor()
    		case "red":
    			return UIColor.redColor()
    		case "green":
    			return UIColor.greenColor()
    		case "blue":
    			return UIColor.blueColor()
    		case "cyan":
    			return UIColor.cyanColor()
    		case "yellow":
    			return UIColor.yellowColor()
    		case "magenta":
    			return UIColor.magentaColor()
    		case "orange":
    			return UIColor.orangeColor()
    		case "purple":
    			return UIColor.purpleColor()
    		case "brown":
    			return UIColor.brownColor()
    		default:
    			return nil
    	}
    }
}