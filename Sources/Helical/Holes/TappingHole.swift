import Cadova

/// A pilot hole for a tapping screw, which forms its own mating thread as it is driven in.
///
/// The hole is sized to the screw's minor diameter, so the core of the screw passes through
/// while the thread crests bite into the surrounding material.
public struct TappingHole: Geometry3D {
    /// The nominal hole diameter, before tolerance is applied.
    public let diameter: Double
    /// The depth of the hole.
    public let depth: Double

    /// Creates a tapping hole sized for a screw thread.
    ///
    /// - Parameters:
    ///   - thread: The thread of the screw that will form its own thread in this hole.
    ///   - depth: The depth of the hole.
    public init(thread: ScrewThread, depth: Double) {
        self.init(diameter: thread.minorDiameter, depth: depth)
    }

    /// Creates a tapping hole with an explicit diameter.
    ///
    /// Useful where the material calls for more or less thread engagement than the screw's
    /// minor diameter gives.
    ///
    /// - Parameters:
    ///   - diameter: The nominal hole diameter.
    ///   - depth: The depth of the hole.
    public init(diameter: Double, depth: Double) {
        self.diameter = diameter
        self.depth = depth
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance

        Cylinder(diameter: diameter + tolerance, height: depth)
            .overhangSafe()
    }
}
