//
//  LocationStorage.swift
//  VisitTracking
//
//  Created by Ankit Kumar on 26/02/2019.
//  Copyright © 2019 Ankit Kumar. All rights reserved.
//

import Foundation
class LocationStorage {
    static let shared = LocationStorage()
    
    private(set) var locations: [Location]
    
    private let fileManager: FileManager
    private let documentsURL: URL

    init() {
        let fileManager = FileManager.default
        documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        self.fileManager = fileManager
        let jsonDecoder = JSONDecoder()
        
        // 1 Get URLs for all files in the Documents folder.
        let locationFilesURLs = try! fileManager
            .contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        locations = locationFilesURLs.compactMap { url -> Location? in
            // 2 skip ds files
            guard !url.absoluteString.contains(".DS_Store") else {
                return nil
            }
            // 3 read data from file
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            // 4  Decode the raw data into Location objects — thanks Codable 👍.
            return try? jsonDecoder.decode(Location.self, from: data)
            // 5 Sort locations by date.
            }.sorted(by: { $0.date < $1.date })
        
    }
}
