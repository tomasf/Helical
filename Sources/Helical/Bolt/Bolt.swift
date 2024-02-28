import Foundation
import SwiftSCAD

public struct Bolt: Shape3D {
    public let thread: ScrewThread
    let length: Double
    let shankLength: Double
    let shankDiameter: Double
    let leadinChamferSize: Double
    let headShape: (any BoltHeadShape)?
    let socket: (any BoltHeadSocket)?

    public init(thread: ScrewThread, length: Double, shankLength: Double = 0, shankDiameter: Double? = nil, leadinChamferSize: Double, headShape: (any BoltHeadShape)?, socket: (any BoltHeadSocket)? = nil) {
        self.thread = thread
        self.length = length
        self.shankLength = shankLength
        self.shankDiameter = shankDiameter ?? thread.majorDiameter
        self.leadinChamferSize = leadinChamferSize
        self.headShape = headShape
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
        let head = headShape as? any Geometry3D ?? Box(.zero)
        let baseLevel = (headShape?.height ?? 0) - (headShape?.boltLength ?? 0)

        EnvironmentReader { environment in
            head
                .adding {
                    // Shank
                    Cylinder(diameter: shankDiameter - environment.tolerance, height: shankLength)
                        .translated(z: baseLevel)

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
                        .translated(z: baseLevel + shankLength)
                }
                .subtracting {
                    if let socket {
                        socket.translated(z: -0.01)
                    }
                }
        }
    }


    private func clearanceHoleDepth(recessedHead: Bool = false) -> Double {
        guard let headShape else { return length }
        return recessedHead ? (length + headShape.clearanceLength) : (length - headShape.boltLength)
    }

    public func clearanceHole(depth: Double? = nil, edgeProfile: EdgeProfile = .sharp) -> ClearanceHole {
        ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(),
            edgeProfile: edgeProfile
        )
    }

    public func clearanceHole(depth: Double? = nil, recessedHead: Bool) -> ClearanceHole {
        let recess: (any BoltHeadRecess)? = if recessedHead, let headShape { headShape.recess } else { nil }
        return ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(recessedHead: true),
            boltHeadRecess: recess
        )
    }
}
