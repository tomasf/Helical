import Foundation
import Cadova

public struct CountersunkBoltHeadShape: BoltHeadShape {
    let countersink: Countersink
    let boltDiameter: Double
    let lensHeight: Double

    @Environment(\.tolerance) var tolerance

    public init(countersink: Countersink, boltDiameter: Double, lensHeight: Double = 0) {
        self.countersink = countersink
        self.boltDiameter = boltDiameter
        self.lensHeight = lensHeight
    }

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

    public var boltLength: Double {
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

    public var recess: (any Geometry3D)? {
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

