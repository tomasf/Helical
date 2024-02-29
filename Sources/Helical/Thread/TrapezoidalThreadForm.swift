import Foundation
import SwiftSCAD

/// Trapezoidal threadforms, of which V-shaped threads and square threads are subsets
public struct TrapezoidalThreadForm: ThreadForm {
    let angle: Angle
    let crestWidth: Double

    public init(angle: Angle = 60°, crestWidth: Double) {
        self.angle = angle
        self.crestWidth = crestWidth
    }

    public func shape(for thread: ScrewThread) -> Polygon {
        let slopeLength = thread.depth / tan(90° - angle / 2)

        return Polygon([
            [0, -crestWidth / 2 - slopeLength],
            [0, crestWidth / 2 + slopeLength],
            [thread.depth, crestWidth / 2],
            [thread.depth, -crestWidth / 2],
        ])
    }

    public func pitchDiameter(for thread: ScrewThread) -> Double {
        thread.majorDiameter + (crestWidth - thread.pitch / 2) / tan(angle / 2)
    }
}

public extension ThreadForm where Self == TrapezoidalThreadForm {
    static func trapezoidal(angle: Angle = 60°, crestWidth: Double) -> Self {
        TrapezoidalThreadForm(angle: angle, crestWidth: crestWidth)
    }
}
