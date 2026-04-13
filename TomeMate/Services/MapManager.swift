//
//  MapManager.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-04-10.
//

// MapManager.swift
import MapKit
import UIKit

class MapManager: MKTileOverlay {
    // 1. Create a memory cache
        private let cache = NSCache<NSString, NSData>()
        
        private let blackTileData: Data = {
            let size = CGSize(width: 256, height: 256)
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { ctx in
                UIColor.black.setFill()
                ctx.fill(CGRect(origin: .zero, size: size))
            }.pngData()!
        }()
    
    override init(urlTemplate: String?) {
        super.init(urlTemplate: "")
        self.canReplaceMapContent = true
        self.minimumZ = 1
        self.maximumZ = 6
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
            let cacheKey = "\(path.z)-\(path.x)-\(path.y)" as NSString
            
            // 2. Check Cache first
            if let cachedData = cache.object(forKey: cacheKey) {
                result(cachedData as Data, nil)
                return
            }

            // 3. Run disk loading on a background thread to keep UI smooth
            DispatchQueue.global(qos: .userInteractive).async {
                let flippedY = (1 << path.z) - 1 - path.y
                let tilePath = "\(Bundle.main.bundlePath)/tiles/z\(path.z)/\(path.x)/\(flippedY).png"
                
                let dataToReturn: Data
                if FileManager.default.fileExists(atPath: tilePath),
                   let data = try? Data(contentsOf: URL(fileURLWithPath: tilePath)) {
                    dataToReturn = data
                } else {
                    dataToReturn = self.blackTileData
                }

                // 4. Save to cache and return to main thread
                self.cache.setObject(dataToReturn as NSData, forKey: cacheKey)
                DispatchQueue.main.async {
                    result(dataToReturn, nil)
                }
            }
        }
    }
