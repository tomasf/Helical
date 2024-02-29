import Foundation
import SwiftSCAD

public struct Bolt: Shape3D {
    public let thread: ScrewThread
    let length: Double
    let shankLength: Double
    let shankDiameter: Double
    let headShape: any BoltHeadShape
    let socket: (any BoltHeadSocket)?
    let point: (any BoltPoint)?

    init(thread: ScrewThread, length: Double, shankLength: Double, shankDiameter: Double? = nil, headShape: any BoltHeadShape, socket: (any BoltHeadSocket)?, point: (any BoltPoint)?) {
        self.thread = thread
        self.length = length
        self.shankLength = shankLength
        self.shankDiameter = shankDiameter ?? thread.majorDiameter
        self.headShape = headShape
        self.socket = socket
        self.point = point
    }

    public init(thread: ScrewThread, length: Double, shankLength: Double = 0, shankDiameter: Double? = nil, leadinChamferSize: Double, headShape: any BoltHeadShape, socket: (any BoltHeadSocket)? = nil) {
        self.init(
            thread: thread,
            length: length,
            shankLength: shankLength,
            shankDiameter: shankDiameter,
            headShape: headShape,
            socket: socket,
            point: ChamferedBoltPoint(thread: thread, chamfer: .chamfer(size: leadinChamferSize))
        )
    }

    public init(thread: ScrewThread, length: Double, shankLength: Double = 0, shankDiameter: Double? = nil, headShape: any BoltHeadShape, socket: (any BoltHeadSocket)? = nil) {
        self.init(
            thread: thread,
            length: length,
            shankLength: shankLength,
            shankDiameter: shankDiameter ?? thread.majorDiameter,
            leadinChamferSize: thread.depth,
            headShape: headShape,
            socket: socket
        )
    }

    public var body: any Geometry3D {
        let baseLevel = headShape.height - headShape.boltLength
        let threadLength = length - shankLength - (point?.boltLength ?? 0)

        EnvironmentReader { environment in
            headShape
                .adding {
                    // Shank
                    Cylinder(diameter: shankDiameter - environment.tolerance, height: shankLength)
                        .translated(z: baseLevel)

                    // Threads
                    Screw(thread: thread, length: threadLength, convexity: 4)
                        .translated(z: baseLevel + shankLength)

                    // Point
                    if let point {
                        point
                            .translated(z: baseLevel + shankLength + threadLength)
                    }
                }
                .subtracting {
                    headShape.negativeBody
                    if let socket {
                        socket.translated(z: -0.01)
                    }
                    if let point {
                        point.negativeBody
                            .translated(z: baseLevel + shankLength + threadLength)
                    }
                }
        }
    }

    private func clearanceHoleDepth(recessedHead: Bool = false) -> Double {
        recessedHead ? (length + headShape.clearanceLength) : (length - headShape.boltLength)
    }

    public func clearanceHole(depth: Double? = nil, edgeProfile: EdgeProfile = .sharp) -> ClearanceHole {
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
