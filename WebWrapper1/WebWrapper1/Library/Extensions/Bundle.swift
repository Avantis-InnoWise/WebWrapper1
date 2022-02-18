//
//  Bundle.swift
//  WebWrapper1
//
//  Created by user on 17.02.2022.
//

import Cocoa

extension Bundle {
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
