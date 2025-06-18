import Foundation
import Cadova

public struct Screw: Shape3D {
    let thread: ScrewThread
    let length: Double

    public init(thread: ScrewThread, length: Double) {
        self.thread = thread
        self.length = length
    }

    public var body: any Geometry3D {
        @Environment(\.relativeTolerance) var relativeTolerance

        if length > 0 {
            let minorRadius = (thread.minorDiameter + relativeTolerance) / 2

            thread.form
                .transformed(.translation(x: minorRadius))
                .sweptAlongHelix(pitch: thread.lead, height: length + thread.pitch)
                .translated(z: -thread.pitch / 2)
                .repeated(around: .z, in: 0°..<360°, count: thread.starts)
                .flipped(along: thread.leftHanded ? .x : .none)
                .within(z: 0..<length)
                .adding {
                    Cylinder(radius: minorRadius + 0.01, height: length)
                }
        }
    }
}

internal extension EnvironmentValues {
    var relativeTolerance: Double {
        if operation == .subtraction {
            return tolerance
        } else {
            return -tolerance
        }
    }
}
