import Foundation
import SwiftSCAD

struct Bolt: Shape3D {
    let thread: ScrewThread
    let length: Double
    let shankLength: Double
    let shankDiameter: Double
    let leadinChamferSize: Double
    let headShape: any BoltHeadShape
    let socket: (any BoltHeadSocket)?

    init(thread: ScrewThread, length: Double, shankLength: Double = 0, shankDiameter: Double? = nil, leadinChamferSize: Double, headShape: any BoltHeadShape, socket: (any BoltHeadSocket)? = nil) {
        self.thread = thread
        self.length = length
        self.shankLength = shankLength
        self.shankDiameter = shankDiameter ?? thread.majorDiameter
        self.leadinChamferSize = leadinChamferSize
        self.headShape = headShape
        self.socket = socket
    }

    init(thread: ScrewThread, length: Double, shankLength: Double = 0, shankDiameter: Double? = nil, headShape: any BoltHeadShape, socket: (any BoltHeadSocket)? = nil) {
        self.thread = thread
        self.length = length
        self.shankLength = shankLength
        self.shankDiameter = shankDiameter ?? thread.majorDiameter
        self.leadinChamferSize = thread.depth
        self.headShape = headShape
        self.socket = socket
    }

    var body: any Geometry3D {
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
                                    .extruded(height: length - shankLength, topEdge: .chamfer(size: leadinChamferSize), method: .convexHull)
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

    func clearanceHole(depth: Double? = nil, edgeProfile: EdgeProfile = .sharp) -> ClearanceHole {
        ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(),
            edgeProfile: edgeProfile
        )
    }

    func clearanceHole(depth: Double? = nil, recessedHead: Bool) -> ClearanceHole {
        ClearanceHole(
            diameter: thread.majorDiameter,
            depth: depth ?? clearanceHoleDepth(recessedHead: true),
            boltHeadRecess: recessedHead ? headShape.recess : nil
        )
    }
}


