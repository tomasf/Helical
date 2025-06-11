import Foundation
import Cadova

public struct SlottedBoltHeadSocket: BoltHeadSocket {
    let length: Double
    let width: Double
    public let depth: Double

    @Environment(\.tolerance) var tolerance

    public init(length: Double, width: Double, depth: Double) {
        self.length = length
        self.width = width
        self.depth = depth
    }

    public var body: any Geometry3D {
        Box([length + 1, width + tolerance, depth])
            .aligned(at: .centerXY)
    }
}

public extension BoltHeadSocket where Self == SlottedBoltHeadSocket {
    static func slotted(length: Double, width: Double, depth: Double) -> Self {
        SlottedBoltHeadSocket(length: length, width: width, depth: depth)
    }
}
