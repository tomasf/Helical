import Foundation
import Cadova

/// A bare threaded cylinder.
///
/// `Screw` represents just the threaded geometry — a helical profile swept along a cylinder.
/// It has no head, socket, or point. Use ``Bolt`` for a complete fastener with head and drive.
public struct Screw: Shape3D {
    let thread: ScrewThread
    let length: Double
    let leadIns: LeadInEnds

    /// Creates a screw with the given thread, length, and optional lead-in chamfers.
    ///
    /// - Parameters:
    ///   - thread: The screw thread definition.
    ///   - length: The axial length of the threaded portion.
    ///   - leadIns: Lead-in chamfers for the ends of the screw. Defaults to none.
    public init(thread: ScrewThread, length: Double, leadIns: LeadInEnds = .none) {
        self.thread = thread
        self.length = length
        self.leadIns = leadIns
    }

    public var body: any Geometry3D {
        @Environment(\.relativeTolerance) var relativeTolerance
        @Environment(\.segmentation) var segmentation

        if length > 0 {
            let minorRadius = (thread.minorDiameter + relativeTolerance) / 2
            let majorRadius = (thread.majorDiameter + relativeTolerance) / 2
            let segmentCount = segmentation.segmentCount(circleRadius: majorRadius)
            let circle = Circle(diameter: thread.majorDiameter + relativeTolerance)

            thread.form
                .translated(x: minorRadius)
                .sweptAlongHelix(pitch: thread.lead, height: length + thread.pitch)
                .repeated(around: .z, count: thread.starts)
                .flipped(along: thread.leftHanded ? .x : .none)
                .adding {
                    Cylinder(radius: minorRadius, height: length + thread.pitch)
                }
                .translated(z: -thread.pitch / 2)
                .within(z: 0..<length)
                .applyingLeadIn(leadIns.trailing, thread: thread, on: .maxZ, shape: circle)
                .applyingLeadIn(leadIns.leading, thread: thread, on: .minZ, shape: circle)
                .withThread(thread)
                .withSegmentation(count: segmentCount)
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
