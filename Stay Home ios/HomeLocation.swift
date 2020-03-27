//
//  HomeLocationLoader.swift
//  Stay Home ios
//
//  Created by Vishnu Ravi on 3/27/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import Foundation

struct HomeLocation: Codable {
    var latitude: Double
    var longitude: Double
}

class HomeLocationLoader {
    static private var plistURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("HomeLocation.plist")
    }
    
    static func load() -> HomeLocation {
        let decoder = PropertyListDecoder()
        
        guard let data = try? Data.init(contentsOf: plistURL),
            let homeLocation = try? decoder.decode(HomeLocation.self, from: data)
            else { return HomeLocation(latitude: 0, longitude: 0) }
        
        return homeLocation
    }
    
    static func copyPreferencesFromBundle() {
        // check if a plist exists in the documents directory, else copy it over from the bundle
        
        if let path = Bundle.main.path(forResource: "HomeLocation", ofType: "plist"),
            let data = FileManager.default.contents(atPath: path),
            FileManager.default.fileExists(atPath: plistURL.path) == false {
            FileManager.default.createFile(atPath: plistURL.path, contents: data, attributes: nil)
        }
    }
}

extension HomeLocationLoader {
    static func write(homeLocation: HomeLocation) {
        let encoder = PropertyListEncoder()
        
        if let data = try? encoder.encode(homeLocation) {
            if FileManager.default.fileExists(atPath: plistURL.path) {
                // Update an existing plist
                try? data.write(to: plistURL)
            } else {
                // Create a new plist
                FileManager.default.createFile(atPath: plistURL.path, contents: data, attributes: nil)
            }
        }
    }
}
