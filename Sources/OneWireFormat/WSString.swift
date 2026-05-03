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
    
    /// Пакет серверных событий в формате JSON с массивом `objects`.
    public struct EventsPack: Sendable {
        /// Распознанные элементы
        public let objects: [Event]
    }
    
    public struct Event: Sendable {
        /// Тип прилетевшего события
        public let type: String
        public let id: String?
        public let timestamp: String?
        public let event_type: String?
        public let source: String?
        /// Событие целиком. Будет декодировано полностью потом. Там где это нужно и где понимают "а что там на самом деле".
        /// примеры:
        /// {             "id" : "661e0226-fc00-4b29-bcbe-57ae32dde463",             "source" : "hosts/Demoserver/DeviceIpint.1/SourceEndpoint.video:0:0",         "state" : "CS_Arm",             "timestamp" : "20260403T123542.757638",             "type" : "cameraarmstateevent"         }
        /// {             "event_type" : "faceAppeared",             "faceInfo" :              {                 "age" : 0,             "gender" : 0             },             "id" : "fc908c61-f4d7-40a3-a7ed-77e05c489c5d",             "rectangles" :              [                 {         "bottom" : 0.37888888888888889,                     "index" : 10391854,                     "left" : 0.31937500000000002,                     "right" : 0.39156250000000004,                     "top" : 0.18962962962962965                 }             ],             "source" : "hosts/Demoserver/DeviceIpint.1/SourceEndpoint.video:0:0",             "state" : 0,             "timestamp" : "20260403T125856.734000",             "type" : "detector_event"         }
        /// {             "event_type" : "plateRecognized",             "id" : "26f779bd-eca3-444d-931b-bc67b3a6029e",             "plate_full" : "LO6259L",             "rectangles" :              [                 {                     "bottom" : 0.62152777777777779,                     "index" : 0,                     "left" : 0.63020833333333337,                     "right" : 0.81380208333333337,                     "top" : 0.55208333333333337 }             ],             "source" : "hosts/Demoserver/DeviceIpint.3/SourceEndpoint.video:0:0",             "state" : 0,             "timestamp" : "20260403T125856.678000",             "type" : "detector_event"         }
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
