import Foundation
import Cadova

/// A trapezoidal thread profile. V-shaped, square, and buttress threads are specific cases.
public struct TrapezoidalThreadform: Threadform {
    /// Flank angle on the positive-y (thread advancement) side.
    public let leadingFlankAngle: Angle
    /// Flank angle on the negative-y side.
    public let trailingFlankAngle: Angle
    let crestWidth: Double

    /// The included thread angle (sum of both flank angles).
    public var angle: Angle { leadingFlankAngle + trailingFlankAngle }

    /// Creates a trapezoidal threadform with the given flank angle and crest width.
    ///
    /// Both flanks use half the included angle, producing a symmetric profile.
    ///
    /// - Parameters:
    ///   - angle: Included thread angle. Defaults to 60°.
    ///   - crestWidth: Width of the crest at the outer diameter.
    ///
    public init(angle: Angle = 60°, crestWidth: Double) {
        self.leadingFlankAngle = angle / 2
        self.trailingFlankAngle = angle / 2
        self.crestWidth = crestWidth
    }

    /// Creates a trapezoidal threadform with independent flank angles.
    ///
    /// - Parameters:
    ///   - leadingFlankAngle: Flank angle on the thread advancement side.
    ///   - trailingFlankAngle: Flank angle on the opposite side.
    ///   - crestWidth: Width of the crest at the outer diameter.
    ///
    public init(leadingFlankAngle: Angle, trailingFlankAngle: Angle, crestWidth: Double) {
        self.leadingFlankAngle = leadingFlankAngle
        self.trailingFlankAngle = trailingFlankAngle
        self.crestWidth = crestWidth
    }

    public var body: any Geometry2D {
        @Environment(\.thread!) var thread
        let leadingSlopeLength = thread.depth / tan(90° - leadingFlankAngle)
        let trailingSlopeLength = thread.depth / tan(90° - trailingFlankAngle)
        let leadingInsetY = innerInset * leadingSlopeLength / thread.depth
        let trailingInsetY = innerInset * trailingSlopeLength / thread.depth

        return Polygon([
            [-innerInset, -crestWidth / 2 - trailingSlopeLength - trailingInsetY],
            [-innerInset, crestWidth / 2 + leadingSlopeLength + leadingInsetY],
            [thread.depth, crestWidth / 2],
            [thread.depth, -crestWidth / 2],
        ])
    }

    public func minimumPitch(for thread: ScrewThread) -> Double {
        crestWidth + thread.depth * (tan(leadingFlankAngle) + tan(trailingFlankAngle))
    }

    /// Returns the pitch diameter for a thread using this profile.
    ///
    /// - Parameter thread: The screw thread to evaluate.
    /// - Returns: The pitch diameter.
    ///
    public func pitchDiameter(for thread: ScrewThread) -> Double {
        thread.majorDiameter + 2 * (crestWidth - thread.pitch / 2) / (tan(leadingFlankAngle) + tan(trailingFlankAngle))
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

    /// Creates a trapezoidal threadform with independent flank angles.
    ///
    /// - Parameters:
    ///   - leadingFlankAngle: Flank angle on the thread advancement side.
    ///   - trailingFlankAngle: Flank angle on the opposite side.
    ///   - crestWidth: Width of the crest at the outer diameter.
    /// - Returns: A trapezoidal threadform instance.
    ///
    static func trapezoidal(leadingFlankAngle: Angle, trailingFlankAngle: Angle, crestWidth: Double) -> Self {
        TrapezoidalThreadform(leadingFlankAngle: leadingFlankAngle, trailingFlankAngle: trailingFlankAngle, crestWidth: crestWidth)
    }

    /// Creates a buttress threadform with asymmetric flank angles.
    ///
    /// - Parameters:
    ///   - leadingFlankAngle: Flank angle on the thread advancement side. Defaults to 7°.
    ///   - trailingFlankAngle: Flank angle on the opposite side. Defaults to 45°.
    ///   - crestWidth: Width of the crest at the outer diameter.
    /// - Returns: A buttress threadform instance.
    ///
    static func buttress(leadingFlankAngle: Angle = 7°, trailingFlankAngle: Angle = 45°, crestWidth: Double) -> Self {
        TrapezoidalThreadform(leadingFlankAngle: leadingFlankAngle, trailingFlankAngle: trailingFlankAngle, crestWidth: crestWidth)
    }
}
