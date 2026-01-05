import Foundation
import Cadova

/// A conical countersunk bolt head that sits flush with or below the mounting surface.
///
/// Optionally includes a raised lens (dome) above the cone. The head height is included
/// in the nominal bolt length.
public struct CountersunkBoltHeadShape: BoltHeadShape {
    let countersink: Countersink
    let boltDiameter: Double
    let lensHeight: Double

    @Environment(\.tolerance) var tolerance

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
        let effectiveTopDiameter = countersink.topDiameter - tolerance
        let coneHeight = effectiveTopDiameter / 2 * tan(countersink.angle / 2)

        Cylinder(bottomDiameter: effectiveTopDiameter, topDiameter: 0.001, height: coneHeight)
            .translated(z: lensHeight)
            .adding {
                if lensHeight > 0 {
                    let diameter = lensHeight + pow(effectiveTopDiameter, 2) / (4 * lensHeight)
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
    static func countersunk(
        angle: Angle = 90°,
        topDiameter: Double,
        boltDiameter: Double
    ) -> CountersunkBoltHeadShape {
        countersunk(countersink: .init(angle: angle, topDiameter: topDiameter), boltDiameter: boltDiameter)
    }

    static func countersunk(
        countersink: Countersink,
        boltDiameter: Double
    ) -> CountersunkBoltHeadShape {
        .init(countersink: countersink, boltDiameter: boltDiameter)
    }

    static func standardCountersunk(topDiameter: Double, boltDiameter: Double) -> CountersunkBoltHeadShape {
        .init(countersink: .init(angle: 90°, topDiameter: topDiameter), boltDiameter: boltDiameter)
    }
}

