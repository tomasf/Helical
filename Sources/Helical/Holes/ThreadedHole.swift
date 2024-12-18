import Foundation
import SwiftSCAD

public struct ThreadedHole: Shape3D {
    let thread: ScrewThread
    let depth: Double
    let unthreadedDepth: Double
    let leadinChamferSize: Double
    let entryEnds: Set<AxisDirection>

    public init(thread: ScrewThread, depth: Double, unthreadedDepth: Double = 0, leadinChamferSize: Double, entryEnds: Set<AxisDirection> = [.negative]) {
        self.thread = thread
        self.depth = depth
        self.unthreadedDepth = unthreadedDepth
        self.leadinChamferSize = leadinChamferSize
        self.entryEnds = entryEnds
    }

    public init(thread: ScrewThread, depth: Double, unthreadedDepth: Double = 0, entryEnds: Set<AxisDirection> = [.negative]) {
        let standardChamferSize = thread.depth * 2
        self.init(
            thread: thread,
            depth: depth,
            unthreadedDepth: unthreadedDepth,
            leadinChamferSize: standardChamferSize,
            entryEnds: entryEnds
        )
    }

    public var body: any Geometry3D {
        readTolerance { tolerance in
            Screw(thread: thread, length: depth + 0.02)

            let unthreadedDiameter = thread.majorDiameter + tolerance
            let entry = Circle(diameter: unthreadedDiameter)
                .extruded(height: unthreadedDepth + thread.depth, topEdge: .chamfer(size: thread.depth), method: .convexHull)
                .adding {
                    if leadinChamferSize > 0 {
                        let chamferInnerDiameter = (unthreadedDepth > 0) ? unthreadedDiameter : (thread.minorDiameter + tolerance)

                        EdgeProfile.chamfer(size: leadinChamferSize)
                            .shape()
                            .translated(x: chamferInnerDiameter / 2 - 0.01)
                            .extruded()
                    }
                }

            if entryEnds.contains(.negative) {
                entry
                    .translated(z: -0.01)
            }
            if entryEnds.contains(.positive) {
                entry
                    .flipped(along: .z)
                    .translated(z: depth + 0.02)
            }
        }
        .translated(z: -0.01)
    }
}
