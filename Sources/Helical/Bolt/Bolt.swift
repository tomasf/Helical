import Foundation
import SwiftSCAD

public struct Bolt: Shape3D {
    public let thread: ScrewThread
    let length: Double
    let shankLength: Double
    let shankDiameter: Double
    let leadinChamferSize: Double
    let headShape: any BoltHeadShape
    let socket: (any BoltHeadSocket)?

    public init(thread: ScrewThread, length: Double, shankLength: Double = 0, shankDiameter: Double? = nil, leadinChamferSize: Double, headShape: (any BoltHeadShape)?, socket: (any BoltHeadSocket)? = nil) {
        self.thread = thread
        self.length = length
        self.shankLength = shankLength
        self.shankDiameter = shankDiameter ?? thread.majorDiameter
        self.leadinChamferSize = leadinChamferSize
        self.headShape = headShape ?? NoBoltHeadShape()
        self.socket = socket
    }

    public init(thread: ScrewThread, length: Double, shankLength: Double = 0, shankDiameter: Double? = nil, headShape: (any BoltHeadShape)?, socket: (any BoltHeadSocket)? = nil) {
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
        EnvironmentReader { environment in
            headShape
                .adding {
                    // Shank
                    Cylinder(diameter: shankDiameter - environment.tolerance, height: shankLength)
                        .translated(z: headShape.height - headShape.boltLength)

                    // Threads
                    Screw(thread: thread, length: length - shankLength, convexity: 4)
                        .intersection {
                            if leadinChamferSize > .ulpOfOne {
                                Circle(diameter: thread.majorDiameter)
                                    .extruded(
                                        height: length - shankLength,
                                        topEdge: .chamfer(size: leadinChamferSize),
                                        bottomEdge: .chamfer(size: leadinChamferSize),
                                        method: .convexHull
                                    )
                            }
                        }
                        .translated(z: headShape.height - headShape.boltLength + shankLength)
                }
                .subtracting {
                    if let socket {
                        socket.translated(z: -0.01)
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
        ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(recessedHead: true),
            boltHeadRecess: recessedHead ? headShape.recess : nil
        )
    }
}


private struct NoBoltHeadShape: BoltHeadShape {    
    let height = 0.0
    let recess: any BoltHeadRecess = Recess()
    let body: any Geometry3D = Box(.zero)

    struct Recess: BoltHeadRecess {
        var body: any Geometry3D { Box(.zero) }
    }
}
