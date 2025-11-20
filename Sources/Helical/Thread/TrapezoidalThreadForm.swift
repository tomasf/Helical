import Foundation
import Cadova

/// A trapezoidal thread profile. V-shaped and square threads are specific cases.
public struct TrapezoidalThreadform: Threadform {
    let angle: Angle
    let crestWidth: Double

    /// Creates a trapezoidal threadform with the given flank angle and crest width.
    ///
    /// - Parameters:
    ///   - angle: Included thread angle. Defaults to 60°.
    ///   - crestWidth: Width of the crest at the outer diameter.
    ///
    public init(angle: Angle = 60°, crestWidth: Double) {
        self.angle = angle
        self.crestWidth = crestWidth
    }

    public var body: any Geometry2D {
        @Environment(\.thread!) var thread
        let slopeLength = thread.depth / tan(90° - angle / 2)

        return Polygon([
            [0, -crestWidth / 2 - slopeLength],
            [0, crestWidth / 2 + slopeLength],
            [thread.depth, crestWidth / 2],
            [thread.depth, -crestWidth / 2],
        ])
    }

    /// Returns the pitch diameter for a thread using this profile.
    ///
    /// - Parameter thread: The screw thread to evaluate.
    /// - Returns: The pitch diameter.
    ///
    public func pitchDiameter(for thread: ScrewThread) -> Double {
        thread.majorDiameter + (crestWidth - thread.pitch / 2) / tan(angle / 2)
    }
}

public extension Threadform where Self == TrapezoidalThreadform {
    /// Creates a trapezoidal threadform with the specified flank angle and crest width.
    ///
    /// - Parameters:
    ///   - angle: Included thread angle. Defaults to 60°.
    ///   - crestWidth: Width of the crest at the outer diameter.
    /// - Returns: A trapezoidal threadform instance.
    ///
    static func trapezoidal(angle: Angle = 60°, crestWidth: Double) -> Self {
        TrapezoidalThreadform(angle: angle, crestWidth: crestWidth)
    }
}
