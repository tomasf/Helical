import Foundation
import SwiftSCAD

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
            EdgeProfile.chamfer(size: chamferSize)
                .shape()
                .flipped(along: .x)
                .translated(x: (thread.majorDiameter - tolerance) / 2 + 0.01, y: -0.01)
                .extruded()
                .flipped(along: .z)
        }
    }
}
