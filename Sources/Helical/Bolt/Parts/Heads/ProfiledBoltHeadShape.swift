import Cadova

/// A headless bolt shape for fasteners like set screws and threaded studs.
///
/// Applies an edge profile to the top of the bolt body rather than adding a head.
public struct ProfiledBoltHeadShape: BoltHeadShape {
    let edgeProfile: EdgeProfile

    /// Creates a headless bolt shape with the specified edge profile.
    ///
    /// - Parameter edgeProfile: The edge profile to apply to the top of the bolt body.
    public init(edgeProfile: EdgeProfile) {
        self.edgeProfile = edgeProfile
    }

    public var negativeBody: any Geometry3D {
        @Environment(\.thread!) var thread
        @Environment(\.tolerance) var tolerance

        edgeProfile.profile
            .translated(x: (thread.majorDiameter - tolerance) / 2)
            .revolved()
    }

    public let height = 0.0
    public var body: any Geometry3D {}
    public var recess: any Geometry3D {}
}

public extension BoltHeadShape where Self == ProfiledBoltHeadShape {
    /// A headless bolt shape with a custom edge profile.
    ///
    /// - Parameter edgeProfile: The edge profile to apply to the top of the bolt body.
    static func profile(edgeProfile: EdgeProfile) -> Self {
        .init(edgeProfile: edgeProfile)
    }

    /// A headless bolt shape with a 45° chamfer.
    ///
    /// - Parameter depth: The radial depth of the chamfer.
    static func chamfer(depth: Double) -> Self {
        .init(edgeProfile: .chamfer(depth: depth))
    }
}
