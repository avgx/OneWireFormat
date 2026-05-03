import Foundation

extension Encodable {
    func jsonFormatted() -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}
