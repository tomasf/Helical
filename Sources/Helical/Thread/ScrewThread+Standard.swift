import Foundation
import SwiftSCAD

extension ScrewThread {
    // Standard V-thread profile used for ISO/UTS, etc.
    static func vShapedStandard(majorDiameter: Double, pitch: Double) -> ScrewThread {
        Self(
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch * 1.082532,
            form: TrapezoidalThreadForm(angle: 60°, crestWidth: pitch / 8.0)
        )
    }

    static func acme(majorDiameter: Double, pitch: Double, starts: Int = 1, handedness: Handedness = .right) -> ScrewThread {
        Self(
            handedness: handedness,
            starts: starts,
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch,
            form: TrapezoidalThreadForm(angle: 29°, crestWidth: pitch * 0.3707)
        )
    }

    static func metricTrapezoidal(majorDiameter: Double, pitch: Double, starts: Int = 1, handedness: Handedness = .right) -> ScrewThread {
        Self(
            handedness: handedness,
            starts: starts,
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch,
            form: TrapezoidalThreadForm(angle: 30°, crestWidth: pitch * 0.366)
        )
    }

    static func square(majorDiameter: Double, pitch: Double, starts: Int = 1, handedness: Handedness = .right) -> ScrewThread {
        Self(
            handedness: handedness,
            starts: starts,
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: majorDiameter - pitch,
            form: TrapezoidalThreadForm(angle: 0°, crestWidth: pitch * 0.5)
        )
    }
}
