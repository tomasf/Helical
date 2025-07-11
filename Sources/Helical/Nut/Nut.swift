import Foundation
import Cadova

public struct Nut: Shape3D {
    public let thread: ScrewThread
    public let shape: any NutBody
    let innerChamferAngleBottom: Angle?
    let innerChamferAngleTop: Angle?

    public init(thread: ScrewThread, shape: any NutBody, innerChamferAngleBottom: Angle?, innerChamferAngleTop: Angle?) {
        self.shape = shape
        self.thread = thread
        self.innerChamferAngleBottom = innerChamferAngleBottom
        self.innerChamferAngleTop = innerChamferAngleTop
    }

    public init(thread: ScrewThread, shape: any NutBody, innerChamferAngle: Angle? = nil) {
        self.shape = shape
        self.thread = thread
        self.innerChamferAngleBottom = innerChamferAngle
        self.innerChamferAngleTop = innerChamferAngle
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance
        
        shape
            .subtracting {
                Screw(thread: thread, length: shape.threadedDepth + 0.002)
                    .translated(z: -0.001)

                if let innerChamferAngleBottom {
                    Cylinder(
                        bottomDiameter: thread.majorDiameter + tolerance,
                        topDiameter: thread.minorDiameter + tolerance,
                        height: thread.depth * tan(90° - innerChamferAngleBottom / 2)
                    )
                    .translated(z: -0.01)
                }

                if let innerChamferAngleTop {
                    Cylinder(
                        bottomDiameter: thread.majorDiameter + tolerance,
                        topDiameter: thread.minorDiameter + tolerance,
                        height: thread.depth * tan(90° - innerChamferAngleTop / 2)
                    )
                    .flipped(along: .z)
                    .translated(z: shape.threadedDepth + 0.01)
                }
            }
    }

    public func nutTrap(depthClearance: Double = 0) -> any Geometry3D {
        shape.nutTrap(depthClearance: depthClearance)
    }
}

public protocol NutBody: Shape3D {
    var threadedDepth: Double { get }
    @GeometryBuilder3D func nutTrap(depthClearance: Double) -> any Geometry3D
}

public extension NutBody {
    func nutTrap() -> any Geometry3D {
        nutTrap(depthClearance: 0)
    }
}
