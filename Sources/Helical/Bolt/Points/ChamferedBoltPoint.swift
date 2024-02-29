import Foundation
import SwiftSCAD

public struct ChamferedBoltPoint: BoltPoint {
    let thread: ScrewThread
    let chamfer: EdgeProfile
    let dogPointLength: Double

    public init(thread: ScrewThread, chamfer: EdgeProfile, dogPointLength: Double = 0) {
        self.thread = thread
        self.chamfer = chamfer
        self.dogPointLength = dogPointLength
    }

    public var boltLength: Double { dogPointLength }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            Cylinder(diameter: thread.majorDiameter - chamfer.width * 2, height: dogPointLength)
        }
    }

    public var negativeBody: any Geometry3D {
        EnvironmentReader { environment in
            chamfer.shape()
                .flipped(along: .x)
                .translated(x: (thread.majorDiameter - environment.tolerance) / 2 + 0.01, y: -0.01)
                .extruded()
                .flipped(along: .z)
        }
    }
}

fileprivate extension EdgeProfile {
    var width: Double {
        switch self {
        case .sharp: return 0
        case .fillet(let radius): return radius
        case .chamfer(let width, _): return width
        }
    }
}
