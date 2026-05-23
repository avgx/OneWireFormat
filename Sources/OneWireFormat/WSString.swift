import Foundation

public enum WSString {
    
    enum EventsPackKey: String {
        case objects
    }
    
    enum EventKeys: String {
        case type
        case id
        case timestamp
        case event_type
        case source
    }
    
    /// JSON event pack with an `objects` array.
    public struct EventsPack: Sendable {
        /// Parsed events.
        public let objects: [Event]
    }
    
    public struct Event: Sendable {
        /// Event type.
        public let type: String
        public let id: String?
        public let timestamp: String?
        public let event_type: String?
        public let source: String?
        /// Full event JSON for downstream typed decoding.
        public let raw: Data
        public var rawPayload: String {
            String(data: raw, encoding: .utf8) ?? ""
        }        
    }
    
    public static func decodeEventsPack(from data: Data) throws -> [Event] {
        let root = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let objects = root?[EventsPackKey.objects.rawValue] as? [[String: Any]] else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [], debugDescription: "Expected { \"objects\": [ {...}, ... ] }")
            )
        }
        return try objects.map { obj in
            guard let type = obj[EventKeys.type.rawValue] as? String else {
                throw DecodingError.dataCorrupted(
                    .init(codingPath: [], debugDescription: "Event missing \"type\"")
                )
            }
            let raw = try JSONSerialization.data(withJSONObject: obj, options: [.withoutEscapingSlashes])
            return Event(
                type: type,
                id: obj[EventKeys.id.rawValue] as? String,
                timestamp: obj[EventKeys.timestamp.rawValue] as? String,
                event_type: obj[EventKeys.event_type.rawValue] as? String,
                source: obj[EventKeys.source.rawValue] as? String,
                raw: raw
            )
        }
    }
}

extension WSString.Event: CustomStringConvertible {
    public var description: String {
        rawPayload.debugDescription
    }
}

extension WSString.Event: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(type)|\(event_type ?? "-")|ts:\(timestamp ?? "-")|id:\(id ?? "-")|\(source ?? "-")"
    }
}
