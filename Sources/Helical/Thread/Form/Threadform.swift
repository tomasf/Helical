import Foundation
import Cadova

/// Describes a 2D thread profile capable of providing pitch diameter.
public protocol Threadform: Shape2D {
    /// Returns the pitch diameter for the given thread.
    func pitchDiameter(for thread: ScrewThread) -> Double

    /// Returns the minimum pitch that this threadform requires for the given thread.
    ///
    /// When the actual pitch is smaller than this value, adjacent thread turns overlap
    /// and produce invalid geometry.
    func minimumPitch(for thread: ScrewThread) -> Double
}

extension Threadform {
    var innerInset: Double { 0.001 }
}


internal struct SolidThreadform: Threadform {
    var body: any Geometry2D {
        @Environment(\.thread!) var thread
        Rectangle(x: thread.depth + innerInset, y: thread.pitch)
            .translated(x: -innerInset)
    }

    func minimumPitch(for thread: ScrewThread) -> Double { 0 }

    func pitchDiameter(for thread: ScrewThread) -> Double {
        thread.majorDiameter
    }
}
