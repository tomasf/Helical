import Foundation
import Cadova

/// A threaded hole for receiving a bolt or screw.
///
/// Creates internal threads with optional unthreaded lead-in sections and chamfered entries.
public struct ThreadedHole: Shape3D {
    let thread: ScrewThread
    let depth: Double
    let unthreadedDepth: Double
    let leadinChamferSize: Double
    let entryEnds: Set<LinearDirection>

    /// Creates a threaded hole with the specified parameters.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - depth: Total depth of the threaded portion.
    ///   - unthreadedDepth: Depth of the unthreaded lead-in section.
    ///   - leadinChamferSize: Size of the entry chamfer.
    ///   - entryEnds: Which ends have chamfered entries. Defaults to bottom only.
    public init(thread: ScrewThread, depth: Double, unthreadedDepth: Double = 0, leadinChamferSize: Double, entryEnds: Set<LinearDirection> = [.negative]) {
        self.thread = thread
        self.depth = depth
        self.unthreadedDepth = unthreadedDepth
        self.leadinChamferSize = leadinChamferSize
        self.entryEnds = entryEnds
    }

    /// Creates a threaded hole with a standard chamfer size.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - depth: Total depth of the threaded portion.
    ///   - unthreadedDepth: Depth of the unthreaded lead-in section.
    ///   - entryEnds: Which ends have chamfered entries. Defaults to bottom only.
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
        @Environment(\.tolerance) var tolerance
        Screw(thread: thread, length: depth)

        let unthreadedDiameter = thread.majorDiameter + tolerance
        let entry = Circle(diameter: unthreadedDiameter)
            .extruded(height: unthreadedDepth + thread.depth, topEdge: .chamfer(depth: thread.depth))
            .adding {
                if leadinChamferSize > 0 {
                    let chamferInnerDiameter = (unthreadedDepth > 0) ? unthreadedDiameter : (thread.minorDiameter + tolerance)

                    EdgeProfile.chamfer(depth: leadinChamferSize)
                        .profile
                        .aligned(at: .minX)
                        .translated(x: chamferInnerDiameter / 2, y: leadinChamferSize)
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
