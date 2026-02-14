import Cadova

/// A slotted drive socket for flathead screwdrivers.
public struct SlottedBoltHeadSocket: BoltHeadSocket {
    let length: Double?
    let width: Double
    public let depth: Double

    /// Creates a slotted socket with the specified dimensions.
    ///
    /// - Parameters:
    ///   - length: Length of the slot. When nil, the slot extends across the full head.
    ///   - width: Width of the slot.
    ///   - depth: Depth of the slot.
    public init(length: Double? = nil, width: Double, depth: Double) {
        self.length = length
        self.width = width
        self.depth = depth
    }

    public var body: any Geometry3D {
        @Environment(\.thread!) var thread
        @Environment(\.tolerance) var tolerance

        // When no explicit length, extend well past the head to be clipped by the head shape
        let effectiveLength = length ?? thread.majorDiameter * 4
        Box(x: effectiveLength + tolerance, y: width + tolerance, z: depth)
            .aligned(at: .centerXY)
    }
}

public extension BoltHeadSocket where Self == SlottedBoltHeadSocket {
    /// A slotted drive socket for flathead screwdrivers.
    ///
    /// - Parameters:
    ///   - length: Length of the slot.
    ///   - width: Width of the slot.
    ///   - depth: Depth of the slot.
    static func slot(length: Double? = nil, width: Double, depth: Double) -> Self {
        SlottedBoltHeadSocket(length: length, width: width, depth: depth)
    }
}
