import Foundation

/// Wire timestamp formats used by Axxon Next and Cloud APIs.
public enum Timestamp {
    /// UTC formatter for server wire timestamps.
    public static let utc = Formatter()
    
    /// Local-timezone formatter (fallback parser uses the same time zone).
    public static let local: Formatter = {
        let formatter = Formatter()
        formatter.timeZone = TimeZone.current
        formatter.withoutSeconds.timeZone = TimeZone.current
        return formatter
    }()
}

