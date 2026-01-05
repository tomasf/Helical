import Foundation
import Cadova

/// A bolt point defined by an edge profile, with an optional dog point extension.
///
/// Common profiles include chamfers for standard bolt tips. A dog point adds a
/// reduced-diameter cylindrical extension at the tip.
public struct ProfiledBoltPoint: BoltPoint {
    let profile: EdgeProfile
    let dogPointLength: Double

    /// Creates a bolt point with the specified edge profile.
    ///
    /// - Parameters:
    ///   - profile: The edge profile defining the point shape.
    ///   - dogPointLength: Length of the optional dog point extension. Defaults to zero.
    public init(profile: EdgeProfile, dogPointLength: Double = 0) {
        self.profile = profile
        self.dogPointLength = dogPointLength
    }

    /// Creates a chamfered bolt point.
    ///
    /// - Parameters:
    ///   - chamferSize: Depth of the chamfer.
    ///   - dogPointLength: Length of the optional dog point extension. Defaults to zero.
    public init(chamferSize: Double, dogPointLength: Double = 0) {
        self.init(profile: .chamfer(depth: chamferSize), dogPointLength: dogPointLength)
    }

    public var consumedLength: Double { dogPointLength }

    public var body: any Geometry3D {
        @Environment(\.thread!) var thread
        profile.profile.measuringBounds { _, profileBounds in
            Cylinder(diameter: thread.majorDiameter - profileBounds.size.x * 2, height: dogPointLength)
        }
    }

    public var negativeBody: any Geometry3D {
        @Environment(\.thread!) var thread
        @Environment(\.tolerance) var tolerance

        profile.profile.measuringBounds { _, profileBounds in
            let radius = (thread.majorDiameter - tolerance) / 2 - profileBounds.size.x
            Rectangle(x: thread.majorDiameter, y: profileBounds.size.y)
                .translated(x: radius)
                .subtracting {
                    profile.profile
                        .flipped(along: .y)
                        .translated(x: radius + profileBounds.size.x)
                }
                .revolved()
                .flipped(along: .z)
        }
    }
}
