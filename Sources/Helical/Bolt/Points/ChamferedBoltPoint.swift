import Foundation
import SwiftSCAD

struct ChamferedBoltPoint: BoltPoint {
    let thread: ScrewThread
    let chamfer: EdgeProfile

    var negativeBody: any Geometry3D {
        EnvironmentReader { environment in
            chamfer.shape()
                .flipped(along: .x)
                .translated(x: (thread.majorDiameter - environment.tolerance) / 2 + 0.01, y: -0.01)
                .extruded()
                .flipped(along: .z)
        }
    }
}
