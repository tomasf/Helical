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

    /// Creates a chamfered bolt point with a 45° bevel.
    ///
    /// - Parameters:
    ///   - depth: Radial depth of the chamfer.
    ///   - dogPointLength: Length of the optional dog point extension. Defaults to zero.
    public init(depth: Double, dogPointLength: Double = 0) {
        self.init(profile: .chamfer(depth: depth), dogPointLength: dogPointLength)
    }

    /// Creates a chamfered bolt point with independent radial depth and axial length.
    ///
    /// - Parameters:
    ///   - depth: The radial depth of the chamfer.
    ///   - length: The axial length of the chamfer.
    ///   - dogPointLength: Length of the optional dog point extension. Defaults to zero.
    public init(depth: Double, length: Double, dogPointLength: Double = 0) {
        self.init(profile: .chamfer(depth: depth, height: length), dogPointLength: dogPointLength)
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

public extension BoltPoint where Self == ProfiledBoltPoint {
    /// A chamfered bolt point with a 45° bevel at the tip.
    ///
    /// - Parameter depth: The axial depth of the chamfer.
    static func chamfer(depth: Double) -> Self {
        ProfiledBoltPoint(depth: depth)
    }

    /// A chamfered bolt point with independent radial depth and axial length.
    ///
    /// - Parameters:
    ///   - depth: The radial depth of the chamfer.
    ///   - length: The axial length of the chamfer.
    static func chamfer(depth: Double, length: Double) -> Self {
        ProfiledBoltPoint(depth: depth, length: length)
    }
}
