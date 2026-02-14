import Cadova

/// A threaded nut with configurable body shape and internal lead-in chamfers.
public struct Nut: Shape3D {
    /// The internal screw thread specification.
    public let thread: ScrewThread
    /// The external body shape of the nut.
    public let shape: any NutBody
    /// Lead-in chamfers at the thread entries.
    public let leadIns: LeadInEnds

    /// Creates a nut with the specified thread, body shape, and lead-in chamfers.
    ///
    /// - Parameters:
    ///   - thread: The internal screw thread specification.
    ///   - shape: The external body shape.
    ///   - leadIns: Lead-in chamfers for the thread entries. Defaults to none.
    public init(thread: ScrewThread, shape: any NutBody, leadIns: LeadInEnds = .none) {
        self.shape = shape
        self.thread = thread
        self.leadIns = leadIns
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance

        let minorDiameter = thread.minorDiameter + tolerance
        shape
            .subtracting {
                Screw(thread: thread, length: shape.threadedDepth)

                if let (depth, length) = leadIns.leading?.resolved(for: thread) {
                    Cylinder(bottomDiameter: minorDiameter + 2 * depth, topDiameter: minorDiameter, height: length)
                }

                if let (depth, length) = leadIns.trailing?.resolved(for: thread) {
                    Cylinder(bottomDiameter: minorDiameter, topDiameter: minorDiameter + 2 * depth, height: length)
                        .translated(z: shape.threadedDepth - length)
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
