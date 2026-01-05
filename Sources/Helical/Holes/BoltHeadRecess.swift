import Foundation
import Cadova

/// Parameters defining a conical countersink recess for flat head fasteners.
public struct Countersink: Sendable {
    /// The cone angle of the countersink.
    public let angle: Angle
    /// The diameter at the top (widest part) of the countersink.
    public let topDiameter: Double

    /// Creates a countersink with the specified geometry.
    ///
    /// - Parameters:
    ///   - angle: The cone angle. Defaults to 90°.
    ///   - topDiameter: The diameter at the top of the countersink.
    public init(angle: Angle = 90°, topDiameter: Double) {
        self.angle = angle
        self.topDiameter = topDiameter
    }
}

/// Parameters defining a cylindrical counterbore recess for bolt heads.
public struct Counterbore: Sendable {
    /// The diameter of the counterbore.
    public let diameter: Double
    /// The depth of the counterbore.
    public let depth: Double

    /// Creates a counterbore with the specified dimensions.
    ///
    /// - Parameters:
    ///   - diameter: The diameter of the counterbore.
    ///   - depth: The depth of the counterbore.
    public init(diameter: Double, depth: Double) {
        self.diameter = diameter
        self.depth = depth
    }
}
