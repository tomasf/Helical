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
    ///   - angle: The included cone angle. Defaults to 90°.
    ///   - topDiameter: The diameter at the top of the countersink.
    public init(angle: Angle = 90°, topDiameter: Double) {
        self.angle = angle
        self.topDiameter = topDiameter
    }

    /// The axial depth spanned by a radial distance along the cone wall.
    ///
    /// ``angle`` is the included angle, so the wall sits at `angle / 2` from the axis and the
    /// depth is the radial span divided by its tangent. A wider angle gives a shallower cone.
    ///
    /// - Parameter span: The radial distance travelled along the wall.
    func depth(forRadialSpan span: Double) -> Double {
        span / tan(angle / 2)
    }

    /// The axial depth of the cone, from the rim down to the apex.
    ///
    /// - Parameter topDiameter: The diameter at the rim, which may differ from ``topDiameter``
    ///   once tolerance has been applied.
    func depth(forTopDiameter topDiameter: Double) -> Double {
        depth(forRadialSpan: topDiameter / 2)
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
