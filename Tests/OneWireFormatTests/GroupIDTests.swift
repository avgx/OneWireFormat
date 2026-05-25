import Foundation
import Testing
@testable import OneWireFormat

@Suite("GroupID")
struct GroupIDTests {
    @Test("defaultGroupID is documented root uuid")
    func defaultGroupID() {
        #expect(GroupID.defaultGroupID == "e2f20843-7ce5-d04c-8a4f-826e8b16d39c")
    }
}
