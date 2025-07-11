import Foundation
import Cadova

public struct Countersink: Sendable {
    public let angle: Angle
    public let topDiameter: Double

    public init(angle: Angle = 90°, topDiameter: Double) {
        self.angle = angle
        self.topDiameter = topDiameter
    }
}

public struct Counterbore: Sendable {
    public let diameter: Double
    public let depth: Double

    public init(diameter: Double, depth: Double) {
        self.diameter = diameter
        self.depth = depth
    }
}
