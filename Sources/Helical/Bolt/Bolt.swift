import Foundation
import Cadova

/// A bolt with a head, threaded section, and optional point.
public struct Bolt: Shape3D {
    /// The screw thread specification.
    public let thread: ScrewThread
    /// Nominal length of the bolt, measured according to convention for the head type.
    public let length: Double
    /// Length of the unthreaded portion.
    public let unthreadedLength: Double
    /// Diameter of the unthreaded portion.
    public let unthreadedDiameter: Double
    /// The bolt head geometry.
    public let headShape: any BoltHeadShape
    /// Optional drive socket in the head.
    public let socket: (any BoltHeadSocket)?
    /// Optional bolt point geometry.
    public let point: (any BoltPoint)?

    /// Creates a bolt with the specified thread, dimensions, and head configuration.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    ///   - unthreadedDiameter: Diameter of the unthreaded portion. Defaults to the thread's major diameter.
    ///   - headShape: The bolt head geometry.
    ///   - socket: Optional drive socket in the head.
    ///   - point: Optional bolt point geometry.
    public init(
        thread: ScrewThread,
        length: Double,
        unthreadedLength: Double,
        unthreadedDiameter: Double? = nil,
        headShape: any BoltHeadShape,
        socket: (any BoltHeadSocket)? = nil,
        point: (any BoltPoint)? = nil
    ) {
        self.thread = thread
        self.length = length
        self.unthreadedLength = unthreadedLength
        self.unthreadedDiameter = unthreadedDiameter ?? thread.majorDiameter
        self.headShape = headShape
        self.socket = socket
        self.point = point
    }

    /// Creates a bolt with a chamfered point.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - length: Nominal length of the bolt.
    ///   - unthreadedLength: Length of the unthreaded portion.
    ///   - unthreadedDiameter: Diameter of the unthreaded portion. Defaults to the thread's major diameter.
    ///   - leadinChamferSize: Size of the lead-in chamfer at the bolt tip.
    ///   - headShape: The bolt head geometry.
    ///   - socket: Optional drive socket in the head.
    public init(
        thread: ScrewThread,
        length: Double,
        unthreadedLength: Double = 0,
        unthreadedDiameter: Double? = nil,
        leadinChamferSize: Double,
        headShape: any BoltHeadShape,
        socket: (any BoltHeadSocket)? = nil
    ) {
        self.init(
            thread: thread,
            length: length,
            unthreadedLength: unthreadedLength,
            unthreadedDiameter: unthreadedDiameter,
            headShape: headShape,
            socket: socket,
            point: ProfiledBoltPoint(chamferSize: leadinChamferSize)
        )
    }

    /// Creates a bolt without threads, for cases where thread detail is unimportant.
    ///
    /// - Parameters:
    ///   - solidDiameter: Diameter of the bolt body.
    ///   - length: Nominal length of the bolt.
    ///   - headShape: The bolt head geometry.
    ///   - socket: Optional drive socket in the head.
    ///   - point: Optional bolt point geometry.
    public init(
        solidDiameter: Double,
        length: Double,
        headShape: any BoltHeadShape,
        socket: (any BoltHeadSocket)? = nil,
        point: (any BoltPoint)? = nil
    ) {
        self.init(
            thread: .none(diameter: solidDiameter),
            length: 0,
            unthreadedLength: length,
            unthreadedDiameter: solidDiameter,
            headShape: headShape,
            socket: socket,
            point: point
        )
    }

    public var body: any Geometry3D {
        let baseLevel = headShape.height - headShape.consumedLength
        let threadLength = length - unthreadedLength - (point?.consumedLength ?? 0)

        @Environment(\.tolerance) var tolerance

        headShape
            .adding {
                // Unthreaded part
                Cylinder(diameter: unthreadedDiameter - tolerance, height: unthreadedLength)
                    .translated(z: baseLevel)

                // Threads
                Screw(thread: thread, length: threadLength)
                    .translated(z: baseLevel + unthreadedLength)

                // Point
                point?.translated(z: baseLevel + unthreadedLength + threadLength)
            }
            .subtracting {
                headShape.negativeBody
                socket?.translated(z: -0.01)
                point?.negativeBody
                    .translated(z: baseLevel + unthreadedLength + threadLength)
            }
            .withThread(thread)
    }

    private func clearanceHoleDepth(recessedHead: Bool = false) -> Double {
        recessedHead ? (length + headShape.clearanceLength) : (length - headShape.consumedLength)
    }

    /// Creates a clearance hole sized for this bolt.
    ///
    /// - Parameters:
    ///   - depth: Hole depth. Defaults to the bolt length minus head consumption.
    ///   - edgeProfile: Optional edge profile at the hole opening.
    /// - Returns: A clearance hole configured for this bolt.
    public func clearanceHole(depth: Double? = nil, edgeProfile: EdgeProfile? = nil) -> ClearanceHole {
        ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(),
            edgeProfile: edgeProfile
        )
    }

    /// Creates a clearance hole sized for this bolt, optionally with a recess for the head.
    ///
    /// - Parameters:
    ///   - depth: Hole depth. Defaults to a depth that accommodates the full bolt length.
    ///   - recessedHead: Whether to include a recess matching the bolt head shape.
    /// - Returns: A clearance hole configured for this bolt.
    public func clearanceHole(depth: Double? = nil, recessedHead: Bool) -> ClearanceHole {
        return ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(recessedHead: true),
            boltHeadRecess: recessedHead ? headShape.recess : Empty()
        )
    }
}
