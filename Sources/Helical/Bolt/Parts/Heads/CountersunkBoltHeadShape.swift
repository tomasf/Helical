import Cadova

/// A conical countersunk bolt head that sits flush with or below the mounting surface.
///
/// Optionally includes a raised lens (dome) above the cone. The head height is included
/// in the nominal bolt length.
public struct CountersunkBoltHeadShape: BoltHeadShape {
    let countersink: Countersink
    let boltDiameter: Double
    let lensHeight: Double

    /// Creates a countersunk head with the specified countersink geometry.
    ///
    /// - Parameters:
    ///   - countersink: The countersink geometry defining the cone angle and top diameter.
    ///   - boltDiameter: The bolt's major diameter, used to calculate head height.
    ///   - lensHeight: Height of the optional raised lens above the cone. Defaults to zero.
    public init(countersink: Countersink, boltDiameter: Double, lensHeight: Double = 0) {
        self.countersink = countersink
        self.boltDiameter = boltDiameter
        self.lensHeight = lensHeight
    }

    /// Creates a countersunk head with the specified angle and dimensions.
    ///
    /// - Parameters:
    ///   - angle: The countersink cone angle. Defaults to 90°.
    ///   - topDiameter: The diameter at the top of the cone.
    ///   - boltDiameter: The bolt's major diameter, used to calculate head height.
    ///   - lensHeight: Height of the optional raised lens above the cone. Defaults to zero.
    public init(angle: Angle = 90°, topDiameter: Double, boltDiameter: Double, lensHeight: Double = 0) {
        self.init(
            countersink: Countersink(angle: angle, topDiameter: topDiameter),
            boltDiameter: boltDiameter,
            lensHeight: lensHeight
        )
    }

    public var height: Double {
        (countersink.topDiameter - boltDiameter) / 2 * tan(countersink.angle / 2) + lensHeight
    }

    public var consumedLength: Double {
        height - lensHeight
    }

    public var clearanceLength: Double {
        0
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance
        let effectiveTopDiameter = countersink.topDiameter - tolerance
        let coneHeight = effectiveTopDiameter / 2 * tan(countersink.angle / 2)

        Cylinder(bottomDiameter: effectiveTopDiameter, topDiameter: 0.001, height: coneHeight)
            .translated(z: lensHeight)
            .adding {
                if lensHeight > 0 {
                    let diameter = lensHeight + effectiveTopDiameter * effectiveTopDiameter / (4 * lensHeight)
                    Sphere(diameter: diameter)
                        .aligned(at: .minZ)
                        .within(z: 0..<lensHeight)
                }
            }
    }

    public var recess: any Geometry3D {
        Countersink.Shape(countersink)
    }
}

public extension BoltHeadShape where Self == CountersunkBoltHeadShape {
    /// A countersunk bolt head with a specified cone angle.
    ///
    /// - Parameters:
    ///   - angle: The countersink cone angle. Defaults to 90°.
    ///   - topDiameter: The diameter at the top of the cone.
    ///   - boltDiameter: The bolt's major diameter.
    static func countersunk(
        angle: Angle = 90°,
        topDiameter: Double,
        boltDiameter: Double
    ) -> CountersunkBoltHeadShape {
        .init(
            countersink: Countersink(angle: angle, topDiameter: topDiameter),
            boltDiameter: boltDiameter
        )
    }
}
