import Foundation
import Testing
@testable import OneWireFormat

struct TimestampTests {
    private let utc = Timestamp.utc

    private func utcDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int,
        nanosecond: Int = 0
    ) throws -> Date {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(identifier: "UTC"),
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond
        )
        return try #require(components.date)
    }

    @Test(arguments: [
        ("20260403T123542.757638", 2026, 4, 3, 12, 35, 42, 757_638_000),
        ("20260403T125856.734000", 2026, 4, 3, 12, 58, 56, 734_000_000),
        ("20260330T081832.379813", 2026, 3, 30, 8, 18, 32, 379_813_000),
        ("20260330T081831.618224", 2026, 3, 30, 8, 18, 31, 618_224_000),
        ("20380101T000000.000000", 2038, 1, 1, 0, 0, 0, 0),
        ("20260403T123542", 2026, 4, 3, 12, 35, 42, 0),
        ("20260330T081832", 2026, 3, 30, 8, 18, 32, 0),
        ("20260403T123542.757", 2026, 4, 3, 12, 35, 42, 757_000_000),
        ("20260403T123542.757638000", 2026, 4, 3, 12, 35, 42, 757_638_000),
    ])
    func parse_utcTimestamps(
        string: String,
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int,
        nanosecond: Int
    ) throws {
        let expected = try utcDate(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond
        )
        let parsed = try #require(utc.date(from: string))
        #expect(parsed == expected)
    }

    @Test func roundTrip_utc() throws {
        let original = try utcDate(
            year: 2026,
            month: 4,
            day: 3,
            hour: 12,
            minute: 35,
            second: 42,
            nanosecond: 757_638_000
        )
        let formatted = utc.string(from: original)
        let parsed = try #require(utc.date(from: formatted))
        #expect(parsed == original)
    }

    @Test func localFormatter_usesCurrentTimeZone() {
        #expect(Timestamp.local.timeZone == TimeZone.current)
        #expect(Timestamp.local.withoutSeconds.timeZone == TimeZone.current)
    }

    @Test func utcFormatter_usesUTC() {
        #expect(Timestamp.utc.timeZone == TimeZone(identifier: "UTC"))
    }
}
