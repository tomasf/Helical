import Foundation
import Cadova

public struct Bolt: Shape3D {
    public let thread: ScrewThread
    public let length: Double
    public let shankLength: Double
    public let shankDiameter: Double
    public let headShape: any BoltHeadShape
    public let socket: (any BoltHeadSocket)?
    public let point: (any BoltPoint)?

    public init(
        thread: ScrewThread,
        length: Double,
        shankLength: Double,
        shankDiameter: Double? = nil,
        headShape: any BoltHeadShape,
        socket: (any BoltHeadSocket)? = nil,
        point: (any BoltPoint)? = nil
    ) {
        self.thread = thread
        self.length = length
        self.shankLength = shankLength
        self.shankDiameter = shankDiameter ?? thread.majorDiameter
        self.headShape = headShape
        self.socket = socket
        self.point = point
    }

    public init(
        thread: ScrewThread,
        length: Double,
        shankLength: Double = 0,
        shankDiameter: Double? = nil,
        leadinChamferSize: Double,
        headShape: any BoltHeadShape,
        socket: (any BoltHeadSocket)? = nil
    ) {
        self.init(
            thread: thread,
            length: length,
            shankLength: shankLength,
            shankDiameter: shankDiameter,
            headShape: headShape,
            socket: socket,
            point: ChamferedBoltPoint(chamferSize: leadinChamferSize)
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
            shankLength: length,
            shankDiameter: solidDiameter,
            headShape: headShape,
            socket: socket,
            point: point
        )
    }

    public var body: any Geometry3D {
        let baseLevel = headShape.height - headShape.boltLength
        let threadLength = length - shankLength - (point?.boltLength ?? 0)

        @Environment(\.tolerance) var tolerance

        headShape
            .adding {
                // Shank
                Cylinder(diameter: shankDiameter - tolerance, height: shankLength)
                    .translated(z: baseLevel)

                // Threads
                Screw(thread: thread, length: threadLength)
                    .translated(z: baseLevel + shankLength)

                // Point
                point?.translated(z: baseLevel + shankLength + threadLength)
            }
            .subtracting {
                headShape.negativeBody
                socket?.translated(z: -0.01)
                point?.negativeBody
                    .translated(z: baseLevel + shankLength + threadLength)
            }
            .withThread(thread)
    }

    private func clearanceHoleDepth(recessedHead: Bool = false) -> Double {
        recessedHead ? (length + headShape.clearanceLength) : (length - headShape.boltLength)
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
