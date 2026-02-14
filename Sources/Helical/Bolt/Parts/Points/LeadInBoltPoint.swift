import Foundation
import Cadova

/// A bolt point defined by a ``LeadIn`` chamfer specification.
///
/// Resolves the lead-in size against the bolt's thread at render time.
public struct LeadInBoltPoint: BoltPoint {
    let leadIn: LeadIn

    public var consumedLength: Double { 0 }

    public var negativeBody: any Geometry3D {
        @Environment(\.thread!) var thread
        @Environment(\.tolerance) var tolerance

        let (depth, length) = leadIn.resolved(for: thread)
        let profile = EdgeProfile.chamfer(depth: depth, height: length)
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

public extension BoltPoint where Self == LeadInBoltPoint {
    /// A bolt point using a lead-in chamfer specification.
    ///
    /// The chamfer size is resolved against the bolt's thread at render time.
    ///
    /// - Parameter leadIn: The lead-in specification. Defaults to `.standard`.
    static func leadIn(_ leadIn: LeadIn = .standard) -> Self {
        LeadInBoltPoint(leadIn: leadIn)
    }

    /// A standard 45° chamfered bolt point of 1× thread depth.
    static var chamfer: Self {
        .leadIn()
    }
}
