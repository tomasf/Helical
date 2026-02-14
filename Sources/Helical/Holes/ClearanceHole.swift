import Cadova

/// A clearance hole for a bolt to pass through without threading.
///
/// Supports optional edge profiles, countersinks, or custom head recesses.
public struct ClearanceHole: Shape3D {
    let diameter: Double
    let depth: Double
    let entry: Entry

    /// The geometry at the entry of the clearance hole.
    public enum Entry: Sendable {
        /// No special geometry at the entry.
        case plain
        /// An edge profile applied at the hole opening.
        case edgeProfile (EdgeProfile)
        /// A recess for the bolt head.
        case recess (any Geometry3D)
    }

    /// Creates a clearance hole.
    ///
    /// - Parameters:
    ///   - diameter: The hole diameter (typically the bolt's major diameter).
    ///   - depth: The depth of the hole.
    ///   - entry: The geometry at the entry of the hole. Defaults to `.plain`.
    public init(diameter: Double, depth: Double, entry: Entry = .plain) {
        self.diameter = diameter
        self.depth = depth
        self.entry = entry
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance
        @Environment(\.segmentation) var segmentation
        let effectiveDiameter = diameter + tolerance

        Cylinder(diameter: effectiveDiameter, height: depth)
            .overhangSafe()
            .adding {
                switch entry {
                case .plain:
                    Empty()
                case .edgeProfile(let profile):
                    profile.negativeShape
                        .translated(x: -effectiveDiameter / 2 + 0.001)
                        .flipped(along: .xy)
                        .revolved()
                        .within(z: ...depth)
                        .withSegmentation(count: segmentation.segmentCount(circleRadius: effectiveDiameter / 2))
                case .recess(let recess):
                    recess
                        .within(z: ...depth)
                }
            }
    }
}
