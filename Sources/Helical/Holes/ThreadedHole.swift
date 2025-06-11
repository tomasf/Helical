import Foundation
import Cadova

public struct ThreadedHole: Shape3D {
    let thread: ScrewThread
    let depth: Double
    let unthreadedDepth: Double
    let leadinChamferSize: Double
    let entryEnds: Set<LinearDirection>

    public init(thread: ScrewThread, depth: Double, unthreadedDepth: Double = 0, leadinChamferSize: Double, entryEnds: Set<LinearDirection> = [.negative]) {
        self.thread = thread
        self.depth = depth
        self.unthreadedDepth = unthreadedDepth
        self.leadinChamferSize = leadinChamferSize
        self.entryEnds = entryEnds
    }

    public init(thread: ScrewThread, depth: Double, unthreadedDepth: Double = 0, entryEnds: Set<LinearDirection> = [.negative]) {
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
            Screw(thread: thread, length: depth)

            let unthreadedDiameter = thread.majorDiameter + tolerance
            let entry = Circle(diameter: unthreadedDiameter)
                .extruded(height: unthreadedDepth + thread.depth, topEdge: .chamfer(depth: thread.depth))
                .adding {
                    if leadinChamferSize > 0 {
                        let chamferInnerDiameter = (unthreadedDepth > 0) ? unthreadedDiameter : (thread.minorDiameter + tolerance)

                        EdgeProfile.chamfer(depth: leadinChamferSize)
                            .profile
                            .translated(x: chamferInnerDiameter / 2)
                            .revolved()
                    }
                }

            if entryEnds.contains(.negative) {
                entry
            }
            if entryEnds.contains(.positive) {
                entry
                    .flipped(along: .z)
                    .translated(z: depth)
            }
        }
    }
}
