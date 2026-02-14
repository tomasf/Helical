import Cadova

/// A complete bolt fastener with a head, threaded shank, and optional point.
///
/// `Bolt` composes a head shape, drive socket, threaded section (``Screw``), and point
/// into a full fastener model. For just the bare threaded geometry, use ``Screw``.
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

    /// The entry geometry for a bolt clearance hole.
    public enum ClearanceHoleEntry: Sendable {
        /// No special geometry at the entry.
        case plain
        /// An edge profile applied at the hole opening.
        case edgeProfile (EdgeProfile)
        /// A recess matching the bolt head shape.
        case recessedHead
    }

    /// Creates a clearance hole sized for this bolt.
    ///
    /// The default depth depends on the entry type: for ``ClearanceHoleEntry/recessedHead``,
    /// the hole extends deep enough to fully recess the head; otherwise, it extends
    /// the bolt length minus the head's consumed length.
    ///
    /// - Parameters:
    ///   - depth: Hole depth. Defaults to a depth appropriate for the entry type.
    ///   - entry: The geometry at the entry of the hole. Defaults to `.plain`.
    /// - Returns: A clearance hole configured for this bolt.
    public func clearanceHole(depth: Double? = nil, entry: ClearanceHoleEntry = .plain) -> ClearanceHole {
        let recessedHead: Bool
        let clearanceEntry: ClearanceHole.Entry

        switch entry {
        case .plain:
            recessedHead = false
            clearanceEntry = .plain
        case .edgeProfile(let profile):
            recessedHead = false
            clearanceEntry = .edgeProfile(profile)
        case .recessedHead:
            recessedHead = true
            clearanceEntry = .recess(headShape.recess)
        }

        let defaultDepth = recessedHead
            ? (length + headShape.clearanceLength)
            : (length - headShape.consumedLength)

        return ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? defaultDepth,
            entry: clearanceEntry
        )
    }
}
