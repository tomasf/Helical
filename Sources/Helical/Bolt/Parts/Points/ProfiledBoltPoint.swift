import Foundation
import Cadova

public struct ProfiledBoltPoint: BoltPoint {
    let profile: EdgeProfile
    let dogPointLength: Double

    public init(profile: EdgeProfile, dogPointLength: Double = 0) {
        self.profile = profile
        self.dogPointLength = dogPointLength
    }

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
