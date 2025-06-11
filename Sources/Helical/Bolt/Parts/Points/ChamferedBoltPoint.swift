import Foundation
import Cadova

public struct ChamferedBoltPoint: BoltPoint {
    let thread: ScrewThread
    let chamferSize: Double
    let dogPointLength: Double

    public init(thread: ScrewThread, chamferSize: Double, dogPointLength: Double = 0) {
        self.thread = thread
        self.chamferSize = chamferSize
        self.dogPointLength = dogPointLength
    }

    public var boltLength: Double { dogPointLength }

    public var body: any Geometry3D {
        Cylinder(diameter: thread.majorDiameter - chamferSize * 2, height: dogPointLength)
    }

    public var negativeBody: any Geometry3D {
        readTolerance { tolerance in
            EdgeProfile.chamfer(depth: chamferSize)
                .profile
                .translated(x: (thread.majorDiameter - tolerance) / 2 + 0.01, y: -0.01)
                .revolved()
                .flipped(along: .z)
        }
    }
}
