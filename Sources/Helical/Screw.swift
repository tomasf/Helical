import Foundation
import Cadova

/// A 3D screw model generated from a thread profile and length.
public struct Screw: Shape3D {
    let thread: ScrewThread
    let length: Double
    let chamferFactor: Double

    /// Creates a screw with the given thread, length, and optional chamfer.
    ///
    /// The chamfer is applied on the top (max Z) side of the screw.
    ///
    /// - Parameters:
    ///   - thread: The screw thread definition.
    ///   - length: The axial length of the threaded portion.
    ///   - chamferFactor: Chamfer size as a multiple of thread depth. Defaults to 0.
    ///
    public init(thread: ScrewThread, length: Double, chamferFactor: Double = 0) {
        self.thread = thread
        self.length = length
        self.chamferFactor = chamferFactor
    }

    public var body: any Geometry3D {
        @Environment(\.relativeTolerance) var relativeTolerance
        @Environment(\.segmentation) var segmentation

        if length > 0 {
            let minorRadius = (thread.minorDiameter + relativeTolerance) / 2
            let majorRadius = (thread.majorDiameter + relativeTolerance) / 2
            let chamferDepth = chamferFactor * thread.depth
            let segmentCount = segmentation.segmentCount(circleRadius: majorRadius)
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
                .cuttingEdgeProfile(.chamfer(depth: chamferDepth), on: .maxZ) {
                    Circle(diameter: thread.majorDiameter + relativeTolerance)
                }
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


public struct LeadInEnds: Sendable {
    let leading: LeadIn?
    let trailing: LeadIn?

    init(leading: LeadIn?, trailing: LeadIn?) {
        self.leading = leading
        self.trailing = trailing
    }

    public static func asymmetric(leading: LeadIn, trailing: LeadIn) -> Self {
        .init(leading: leading, trailing: trailing)
    }

    public static func both(_ chamfer: LeadIn) -> Self {
        .init(leading: chamfer, trailing: chamfer)
    }

    public static func leading(_ chamfer: LeadIn) -> Self {
        .init(leading: chamfer, trailing: nil)
    }

    public static func trailing(_ chamfer: LeadIn) -> Self {
        .init(leading: nil, trailing: chamfer)
    }

    public static var none: Self {
        .init(leading: nil, trailing: nil)
    }
}


public struct LeadIn: Sendable {
    let size: Size

    init(size: Size) {
        self.size = size
    }

    // a multiple of the thread depth
    static func threadDepth(multiple: Double) -> Self {
        .init(size: .threadDepth(multiple: multiple))
    }

    static func constant(depth: Double, length: Double) -> Self {
        .init(size: .constant(depth: depth, length: length))
    }

    static func constant(depth: Double) -> Self {
        .init(size: .constant(depth: depth, length: depth))
    }
    
    enum Size: Sendable {
        case constant (depth: Double, length: Double)
        case threadDepth (multiple: Double)
    }
}
