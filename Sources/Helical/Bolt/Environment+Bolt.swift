import Foundation
import Cadova

public extension EnvironmentValues {
    private static let key = Key("Helical.Bolt")

    var bolt: Bolt? {
        get { self[Self.key] as? Bolt }
        set { self[Self.key] = newValue }
    }
}

public extension Geometry {
    /// Sets a bolt as the current one, to be used in bolt parts
    func withBolt(_ bolt: Bolt) -> D.Geometry {
        withEnvironment { $0.bolt = bolt }
    }
}
