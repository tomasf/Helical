import Foundation
import Cadova

public extension ScrewThread {
    /// Creates a standard 60° V-thread commonly used for ISO/UTS profiles.
    ///
    /// Uses a crest width of one-eighth of the pitch and a minor diameter
    /// computed as major diameter minus 1.082532 × pitch.
    ///
    /// - Parameters:
    ///   - majorDiameter: Nominal major diameter in millimeters.
    ///   - pitch: Thread pitch in millimeters.
    /// - Returns: A right-hand, single-start V-thread.
    ///
    static func vShapedStandard(majorDiameter: Double, pitch: Double) -> ScrewThread {
        Self(
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch * 1.082532,
            form: TrapezoidalThreadform(angle: 60°, crestWidth: pitch / 8.0)
        )
    }

    /// Creates an ACME thread profile (29° included angle).
    ///
    /// Minor diameter is set to major diameter minus pitch, and crest width
    /// is 0.3707 × pitch.
    ///
    /// - Parameters:
    ///   - majorDiameter: Nominal major diameter in millimeters.
    ///   - pitch: Thread pitch in millimeters.
    ///   - starts: Number of thread starts. Defaults to 1.
    ///   - handedness: Thread handedness. Defaults to right-hand.
    /// - Returns: An ACME thread with the specified parameters.
    ///
    static func acme(majorDiameter: Double, pitch: Double, starts: Int = 1, handedness: Handedness = .right) -> ScrewThread {
        Self(
            handedness: handedness,
            starts: starts,
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch,
            form: TrapezoidalThreadform(angle: 29°, crestWidth: pitch * 0.3707)
        )
    }

    /// Creates a metric trapezoidal thread (30° included angle).
    ///
    /// Minor diameter is set to major diameter minus pitch, and crest width
    /// is 0.366 × pitch.
    ///
    /// - Parameters:
    ///   - majorDiameter: Nominal major diameter in millimeters.
    ///   - pitch: Thread pitch in millimeters.
    ///   - starts: Number of thread starts. Defaults to 1.
    ///   - handedness: Thread handedness. Defaults to right-hand.
    /// - Returns: A metric trapezoidal thread with the specified parameters.
    ///
    static func metricTrapezoidal(majorDiameter: Double, pitch: Double, starts: Int = 1, handedness: Handedness = .right) -> ScrewThread {
        Self(
            handedness: handedness,
            starts: starts,
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch,
            form: TrapezoidalThreadform(angle: 30°, crestWidth: pitch * 0.366)
        )
    }

    /// Creates a square thread (0° flank angle).
    ///
    /// Minor diameter is set to major diameter minus pitch, and crest width
    /// is 0.5 × pitch.
    ///
    /// - Parameters:
    ///   - majorDiameter: Nominal major diameter in millimeters.
    ///   - pitch: Thread pitch in millimeters.
    ///   - starts: Number of thread starts. Defaults to 1.
    ///   - handedness: Thread handedness. Defaults to right-hand.
    /// - Returns: A square thread with the specified parameters.
    ///
    static func square(majorDiameter: Double, pitch: Double, starts: Int = 1, handedness: Handedness = .right) -> ScrewThread {
        Self(
            handedness: handedness,
            starts: starts,
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch,
            form: TrapezoidalThreadform(angle: 0°, crestWidth: pitch * 0.5)
        )
    }

    /// Creates a unified 60° V-thread using imperial dimensions (UNC/UNF style).
    ///
    /// Converts from inches and threads per inch (TPI) to metric pitch and diameter.
    ///
    /// - Parameters:
    ///   - majorDiameterInches: Nominal major diameter in inches.
    ///   - tpi: Threads per inch.
    /// - Returns: A right-hand, single-start unified-style V-thread.
    ///
    static func unified(majorDiameterInches: Double, tpi: Double) -> ScrewThread {
        .vShapedStandard(
            majorDiameter: majorDiameterInches * 25.4,
            pitch: 25.4 / tpi
        )
    }
}
