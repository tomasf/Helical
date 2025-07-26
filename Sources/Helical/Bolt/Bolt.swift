import Foundation
import Cadova

public struct Bolt: Shape3D {
    public let thread: ScrewThread
    public let length: Double
    public let unthreadedLength: Double
    public let unthreadedDiameter: Double
    public let headShape: any BoltHeadShape
    public let socket: (any BoltHeadSocket)?
    public let point: (any BoltPoint)?

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

    // A bolt without a screw thread, for purposes where the thread is unimportant
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

    public func clearanceHole(depth: Double? = nil, edgeProfile: EdgeProfile? = nil) -> ClearanceHole {
        ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(),
            edgeProfile: edgeProfile
        )
    }

    public func clearanceHole(depth: Double? = nil, recessedHead: Bool) -> ClearanceHole {
        return ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(recessedHead: true),
            boltHeadRecess: headShape.recess
        )
    }
}
