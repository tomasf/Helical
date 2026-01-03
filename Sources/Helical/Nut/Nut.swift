import Foundation
import Cadova

/// A threaded nut with configurable body shape and internal chamfers.
public struct Nut: Shape3D {
    /// The internal screw thread specification.
    public let thread: ScrewThread
    /// The external body shape of the nut.
    public let shape: any NutBody
    let innerChamferAngleBottom: Angle?
    let innerChamferAngleTop: Angle?

    /// Creates a nut with different chamfer angles on each end.
    ///
    /// - Parameters:
    ///   - thread: The internal screw thread specification.
    ///   - shape: The external body shape.
    ///   - innerChamferAngleBottom: Chamfer angle at the bottom thread entry.
    ///   - innerChamferAngleTop: Chamfer angle at the top thread entry.
    public init(thread: ScrewThread, shape: any NutBody, innerChamferAngleBottom: Angle?, innerChamferAngleTop: Angle?) {
        self.shape = shape
        self.thread = thread
        self.innerChamferAngleBottom = innerChamferAngleBottom
        self.innerChamferAngleTop = innerChamferAngleTop
    }

    /// Creates a nut with the same chamfer angle on both ends.
    ///
    /// - Parameters:
    ///   - thread: The internal screw thread specification.
    ///   - shape: The external body shape.
    ///   - innerChamferAngle: Chamfer angle at both thread entries.
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

    /// Creates geometry for a nut trap cavity to hold this nut.
    ///
    /// - Parameter depthClearance: Additional depth beyond the nut thickness.
    /// - Returns: Geometry suitable for subtraction to create a nut trap.
    public func nutTrap(depthClearance: Double = 0) -> any Geometry3D {
        shape.nutTrap(depthClearance: depthClearance)
    }
}

/// A protocol defining the external body shape of a nut.
public protocol NutBody: Shape3D {
    /// The depth of the threaded portion of the nut.
    var threadedDepth: Double { get }
    /// Creates geometry for a nut trap cavity.
    ///
    /// - Parameter depthClearance: Additional depth beyond the nut thickness.
    @GeometryBuilder3D func nutTrap(depthClearance: Double) -> any Geometry3D
}

public extension NutBody {
    /// Creates geometry for a nut trap cavity with no additional clearance.
    func nutTrap() -> any Geometry3D {
        nutTrap(depthClearance: 0)
    }
}
