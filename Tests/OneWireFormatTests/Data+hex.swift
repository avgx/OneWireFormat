import Foundation

extension Data {
    func hexString() -> String {
        self.map { String(format: "%02x", $0) }.joined()
    }
    
    init?(hex: String) {
        let clean = hex.replacingOccurrences(of: " ", with: "")
        guard clean.count % 2 == 0 else { return nil }
        
        var data = Data(capacity: clean.count / 2)
        var index = clean.startIndex
        
        while index < clean.endIndex {
            let next = clean.index(index, offsetBy: 2)
            let byteString = clean[index..<next]
            
            guard let byte = UInt8(byteString, radix: 16) else {
                return nil
            }
            
            data.append(byte)
            index = next
        }
        
        self = data
    }
}
