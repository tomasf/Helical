import Cadova

public extension EnvironmentValues {
    private static let key = Key("Helical.Bolt")

    /// The current screw thread in the environment, used by bolt and nut parts.
    var thread: ScrewThread? {
        get { self[Self.key] as? ScrewThread }
        set { self[Self.key] = newValue }
    }
}

public extension Geometry {
    /// Sets a thread as the current one in the environment for child geometry.
    ///
    /// Used internally by bolt and nut components to share thread information
    /// with their subcomponents.
    ///
    /// - Parameter thread: The screw thread to set in the environment.
    /// - Returns: Geometry with the thread set in its environment.
    func withThread(_ thread: ScrewThread) -> D.Geometry {
        withEnvironment { $0.thread = thread }
    }
}
