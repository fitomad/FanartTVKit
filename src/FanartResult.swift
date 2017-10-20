//
//  FanartResult.swift
//  FanartTVKIT
//
//  Created by Adolfo Vera Blasco on 20/10/17.
//  Copyright © 2017 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

public enum FanartResult<T>
{
    ///
    case success(result: T)
    ///
    case error(reason: String)
}
