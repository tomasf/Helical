import Foundation
import SwiftSCAD

public struct CountersunkBoltHeadShape: BoltHeadShape {
    let countersink: Countersink
    let boltDiameter: Double
    let bottomFilletRadius: Double

    public init(countersink: Countersink, boltDiameter: Double, bottomFilletRadius: Double = 0) {
        self.countersink = countersink
        self.boltDiameter = boltDiameter
        self.bottomFilletRadius = bottomFilletRadius
    }

    public var height: Double {
        (countersink.topDiameter - boltDiameter) / 2 * tan(countersink.angle / 2)
    }

    public var boltLength: Double {
        height
    }

    public var clearanceLength: Double {
        0
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            let effectiveTopDiameter = countersink.topDiameter - environment.tolerance
            let coneHeight = effectiveTopDiameter / 2 * tan(countersink.angle / 2)
            Cylinder(bottomDiameter: effectiveTopDiameter, topDiameter: 0.001, height: coneHeight)

            EdgeProfile.fillet(radius: bottomFilletRadius)
                .shape(angle: 180° - countersink.angle / 2)
                .usingFacets(minAngle: 10°, minSize: bottomFilletRadius / 10)
                .rotated(-90°)
                .flipped(along: .y)
                .translated(x: (boltDiameter - environment.tolerance) / 2)
                .extruded()
                .translated(z: height)
        }
    }

    public var recess: (any BoltHeadRecess)? {
        Countersink.Shape(countersink)
    }
}

public extension BoltHeadShape where Self == CountersunkBoltHeadShape {
    static func countersunk(angle: Angle = 90°, topDiameter: Double, boltDiameter: Double, bottomFilletRadius: Double = 0) -> CountersunkBoltHeadShape {
        countersunk(countersink: .init(angle: angle, topDiameter: topDiameter), boltDiameter: boltDiameter, bottomFilletRadius: bottomFilletRadius)
    }

    static func countersunk(countersink: Countersink, boltDiameter: Double, bottomFilletRadius: Double = 0) -> CountersunkBoltHeadShape {
        .init(countersink: countersink, boltDiameter: boltDiameter, bottomFilletRadius: bottomFilletRadius)
    }

    static func standardCountersunk(topDiameter: Double, boltDiameter: Double) -> CountersunkBoltHeadShape {
        .init(countersink: .init(angle: 90°, topDiameter: topDiameter), boltDiameter: boltDiameter)
    }
}

