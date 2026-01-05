import Foundation
import Cadova

/// A slotted drive socket for flathead screwdrivers.
public struct SlottedBoltHeadSocket: BoltHeadSocket {
    let length: Double
    let width: Double
    public let depth: Double

    @Environment(\.tolerance) var tolerance

    /// Creates a slotted socket with the specified dimensions.
    ///
    /// - Parameters:
    ///   - length: Length of the slot.
    ///   - width: Width of the slot.
    ///   - depth: Depth of the slot.
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
