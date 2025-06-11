import Foundation
import Cadova

public struct CountersunkBoltHeadShape: BoltHeadShape {
    let countersink: Countersink
    let boltDiameter: Double
    let bottomFilletRadius: Double
    let lensHeight: Double

    public init(countersink: Countersink, boltDiameter: Double, bottomFilletRadius: Double = 0, lensHeight: Double = 0) {
        self.countersink = countersink
        self.boltDiameter = boltDiameter
        self.bottomFilletRadius = bottomFilletRadius
        self.lensHeight = lensHeight
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
        readTolerance { tolerance in
            let effectiveTopDiameter = countersink.topDiameter - tolerance
            let coneHeight = effectiveTopDiameter / 2 * tan(countersink.angle / 2)
            Cylinder(bottomDiameter: effectiveTopDiameter, topDiameter: 0.001, height: coneHeight)
                .adding {
                    if bottomFilletRadius > 0 {
                        EdgeProfile.fillet(radius: bottomFilletRadius)
                            .profile //.shape(angle: 180° - countersink.angle / 2)
                            .withSegmentation(minAngle: 10°, minSize: bottomFilletRadius / 10)
                            .rotated(-90°)
                            .flipped(along: .y)
                            .translated(x: (boltDiameter - tolerance) / 2)
                            .revolved()
                            .translated(z: height - lensHeight)
                        #warning("fix")
                    }
                }
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
    }

    public var recess: (any Geometry3D)? {
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

