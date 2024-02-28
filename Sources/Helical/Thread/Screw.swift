import Foundation
import SwiftSCAD

public struct Screw: Shape3D {
    let thread: ScrewThread
    let length: Double
    let convexity: Int

    public init(thread: ScrewThread, length: Double, convexity: Int = 5) {
        self.thread = thread
        self.length = length
        self.convexity = convexity
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            let minorRadius = (thread.minorDiameter + environment.relativeTolerance) / 2

            thread.form.shape(for: thread, in: environment)
                .transformed(.translation(x: minorRadius))
                .extrudedAlongHelix(pitch: thread.lead, height: length + thread.pitch, convexity: convexity)
                .translated(z: -thread.pitch / 2)
                .repeated(around: .z, in: 0°..<360°, count: thread.starts)
                .flipped(along: thread.leftHanded ? .x : .none)
                .intersection {
                    Box([thread.majorDiameter + 2, thread.majorDiameter + 2, length], center: .xy)
                }
                .adding {
                    Cylinder(radius: minorRadius + 0.01, height: length)
                }
        }
    }
}

internal extension Environment {
    var relativeTolerance: Double {
        if operation == .subtraction {
            return tolerance
        } else {
            return -tolerance
        }
    }
}
