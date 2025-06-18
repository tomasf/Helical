import Foundation
import Cadova

public struct ChamferedBoltPoint: BoltPoint {
    let chamferSize: Double
    let dogPointLength: Double

    public init(chamferSize: Double, dogPointLength: Double = 0) {
        self.chamferSize = chamferSize
        self.dogPointLength = dogPointLength
    }

    public var boltLength: Double { dogPointLength }

    public var body: any Geometry3D {
        @Environment(\.thread!) var thread
        Cylinder(diameter: thread.majorDiameter - chamferSize * 2, height: dogPointLength)
    }

    public var negativeBody: any Geometry3D {
        @Environment(\.thread!) var thread
        @Environment(\.tolerance) var tolerance

        EdgeProfile.chamfer(depth: chamferSize)
            .profile
            .translated(x: (thread.majorDiameter - tolerance) / 2 + 0.01, y: -0.01)
            .revolved()
            .flipped(along: .z)
    }
}
