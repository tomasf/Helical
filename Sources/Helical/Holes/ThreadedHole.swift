import Cadova

/// A threaded hole for receiving a bolt or screw.
///
/// Creates internal threads with optional lead-in chamfers at the entries.
public struct ThreadedHole: Shape3D {
    let thread: ScrewThread
    let depth: Double
    let leadIns: LeadInEnds

    /// Creates a threaded hole with the specified parameters.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - depth: Depth of the threaded portion.
    ///   - leadIns: Lead-in chamfers for the ends of the hole. Defaults to none.
    public init(thread: ScrewThread, depth: Double, leadIns: LeadInEnds = .none) {
        self.thread = thread
        self.depth = depth
        self.leadIns = leadIns
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance

        let minorDiameter = thread.minorDiameter + tolerance
        Screw(thread: thread, length: depth)

        if let (depth, length) = leadIns.leading?.resolved(for: thread) {
            Cylinder(bottomDiameter: minorDiameter + 2 * depth, topDiameter: minorDiameter, height: length)
        }

        if let (depth, length) = leadIns.trailing?.resolved(for: thread) {
            Cylinder(bottomDiameter: minorDiameter, topDiameter: minorDiameter + 2 * depth, height: length)
                .translated(z: self.depth - length)
        }
    }
}
