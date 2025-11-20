import Foundation
import Cadova

public extension ScrewThread {
    // Standard V-thread profile used for ISO/UTS, etc.
    static func vShapedStandard(majorDiameter: Double, pitch: Double) -> ScrewThread {
        Self(
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch * 1.082532,
            form: TrapezoidalThreadform(angle: 60°, crestWidth: pitch / 8.0)
        )
    }

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

    /// Creates a unified 60-degree V-thread using imperial dimensions.
    ///
    /// This helper is intended for UNC/UNF-style screw threads where the
    /// size is given as a nominal diameter in inches and a thread count
    /// in threads per inch (TPI).
    ///
    /// - Parameters:
    ///   - majorDiameterInches: Nominal major diameter in inches.
    ///   - tpi: Threads per inch.
    ///
    /// - Returns: A right-hand, single-start thread with a unified-style profile.
    ///
    static func unified(majorDiameterInches: Double, tpi: Double) -> ScrewThread {
        .vShapedStandard(
            majorDiameter: majorDiameterInches * 25.4,
            pitch: 25.4 / tpi
        )
    }
}
