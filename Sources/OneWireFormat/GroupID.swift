import Foundation

/// Wire VMS group id (`group_id` in GroupManager.proto).
public typealias GroupID = String

extension GroupID {
    /// Default root group id seen in VMS and webclient fixtures.
    ///
    /// Documented constant only — not assumed when the server returns a different root.
    public static let defaultGroupID: GroupID = "e2f20843-7ce5-d04c-8a4f-826e8b16d39c"
}
