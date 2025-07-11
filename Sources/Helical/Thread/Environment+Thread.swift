import Foundation
import Cadova

public extension EnvironmentValues {
    private static let key = Key("Helical.Bolt")

    var thread: ScrewThread? {
        get { self[Self.key] as? ScrewThread }
        set { self[Self.key] = newValue }
    }
}

public extension Geometry {
    /// Sets a thread as the current one, to be used in bolt parts
    func withThread(_ thread: ScrewThread) -> D.Geometry {
        withEnvironment { $0.thread = thread }
    }
}
