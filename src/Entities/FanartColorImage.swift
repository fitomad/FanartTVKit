//
//  FanartColorImage.swift
//  FanartTV
//
//  Created by Adolfo Vera Blasco on 21/11/15.
//  Copyright © 2015 Adolfo Vera Blasco. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Foundation

///
/// *Coloured* image related to a Music Label
///
public final class FanartColorImage : FanartBasicImage
{
    /// Color name
    public internal(set) var colorName: String!
    
    #if os(macOS)
    /// Color associated with the color name
    public var color: NSColor?
    {
        switch self.colorName
        {
            case "white":
                return NSColor.white
            case "black":
                return NSColor.black
            case "gray":
                return NSColor.gray
            case "red":
                return NSColor.red
            case "green":
                return NSColor.green
            case "blue":
                return NSColor.blue
            case "cyan":
                return NSColor.cyan
            case "yellow":
                return NSColor.yellow
            case "magenta":
                return NSColor.magenta
            case "orange":
                return NSColor.orange
            case "purple":
                return NSColor.purple
            case "brown":
                return NSColor.brown
            default:
                return nil
            }
    }
    #else
    /// Color associated with the color name
    public var color: UIColor?
    {
        switch self.colorName
        {
            case "white":
                return UIColor.white
            case "black":
                return UIColor.black
            case "gray":
                return UIColor.gray
            case "red":
                return UIColor.red
            case "green":
                return UIColor.green
            case "blue":
                return UIColor.blue
            case "cyan":
                return UIColor.cyan
            case "yellow":
                return UIColor.yellow
            case "magenta":
                return UIColor.magenta
            case "orange":
                return UIColor.orange
            case "purple":
                return UIColor.purple
            case "brown":
                return UIColor.brown
            default:
                return nil
        }
    }
    #endif
}
