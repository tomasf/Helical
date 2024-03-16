import Foundation
import SwiftSCAD

public struct SlottedBoltHeadSocket: BoltHeadSocket {
    let length: Double
    let width: Double
    public let depth: Double

    public init(length: Double, width: Double, depth: Double) {
        self.length = length
        self.width = width
        self.depth = depth
    }

    public var body: any Geometry3D {
        EnvironmentReader { environment in
            Box([length + 1, width + environment.tolerance, depth], center: .xy)
        }
    }
}

public extension BoltHeadSocket where Self == SlottedBoltHeadSocket {
    static func slotted(length: Double, width: Double, depth: Double) -> Self {
        SlottedBoltHeadSocket(length: length, width: width, depth: depth)
    }
}
