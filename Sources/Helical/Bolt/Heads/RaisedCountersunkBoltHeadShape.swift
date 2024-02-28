import Foundation
import SwiftSCAD

public struct RaisedCountersunkBoltHeadShape: BoltHeadShape {
    let countersink: Countersink
    let boltDiameter: Double
    let radius: Double
    let lensHeight: Double

    let includedInLength = true

    public init(countersink: Countersink, boltDiameter: Double, radius: Double = 0, lensHeight: Double) {
        self.countersink = countersink
        self.boltDiameter = boltDiameter
        self.radius = radius
        self.lensHeight = lensHeight
    }

    private var countersunkHead: CountersunkBoltHeadShape {
        .init(countersink: countersink, boltDiameter: boltDiameter, bottomFilletRadius: radius)
    }

    public var height: Double {
        countersunkHead.height + lensHeight
    }

    public var boltLength: Double {
        countersunkHead.boltLength
    }

    public var clearanceLength: Double {
        0
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            let effectiveDiameter = countersink.topDiameter - environment.tolerance
            countersunkHead
                .translated(z: lensHeight)

            let diameter = lensHeight + pow(effectiveDiameter, 2) / (4 * lensHeight)
            Sphere(diameter: diameter)
                .translated(z: diameter / 2)
                .intersection {
                    Box([effectiveDiameter, effectiveDiameter, lensHeight], center: .xy)
                }
        }
    }

    public var recess: (any BoltHeadRecess)? {
        Countersink.Shape(countersink)
    }
}
