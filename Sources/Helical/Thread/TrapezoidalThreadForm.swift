import Foundation
import Cadova

/// Trapezoidal threadforms, of which V-shaped threads and square threads are subsets
public struct TrapezoidalThreadform: Threadform {
    let angle: Angle
    let crestWidth: Double

    public init(angle: Angle = 60°, crestWidth: Double) {
        self.angle = angle
        self.crestWidth = crestWidth
    }

    public func shape(for thread: ScrewThread) -> any Geometry2D {
        let slopeLength = thread.depth / tan(90° - angle / 2)

        Polygon([
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

public extension Threadform where Self == TrapezoidalThreadform {
    static func trapezoidal(angle: Angle = 60°, crestWidth: Double) -> Self {
        TrapezoidalThreadform(angle: angle, crestWidth: crestWidth)
    }
}
