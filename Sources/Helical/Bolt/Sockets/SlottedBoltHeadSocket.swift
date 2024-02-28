import Foundation
import SwiftSCAD

struct SlottedBoltHeadSocket: BoltHeadSocket {
    let length: Double
    let width: Double
    let depth: Double

    var body: any Geometry3D {
        EnvironmentReader { environment in
            Box([length + 1, width + environment.tolerance, depth], center: .xy)
        }
    }
}

extension BoltHeadSocket where Self == SlottedBoltHeadSocket {
    static func slotted(length: Double, width: Double, depth: Double) -> Self {
        SlottedBoltHeadSocket(length: length, width: width, depth: depth)
    }
}
