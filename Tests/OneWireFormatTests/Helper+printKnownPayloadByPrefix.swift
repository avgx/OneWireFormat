import Foundation
//import UIKit    //for UIImage

enum Helper {
    static func printKnownPayloadByPrefix(_ data: Data) {
        guard data.count >= 3 else { return }
        
        let prefix4 = data.prefix(4)
        let prefix3 = data.prefix(3)
        let suffix2 = data.suffix(2)
        
        // MP4
        if prefix4 == Data([0x66, 0x74, 0x79, 0x70]) {
            print("ftyp")
            return
        }
        if prefix4 == Data([0x6d, 0x6f, 0x6f, 0x66]) {
            print("moof")
            return
        }
        
        // JPEG
        if prefix3 == Data([0xff, 0xd8, 0xff]) && suffix2 == Data([0xff, 0xd9]) {
            //let img = UIImage(data: data)
            //print("JPEG \(img?.size ?? .zero)")
            print("JPEG")
            return
        }
        
        let hex = data.hexString()
        if hex.contains("66747970") {
            print("...ftyp")
            return
        }
        if hex.contains("6d6f6f66") {
            print("...moof")
            return
        }
        if hex.contains("ffd8ff") {
            print("...JPEG")
            return
        }
        
        print("unknown: \(hex)")
        return
    }
}
