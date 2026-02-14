import Cadova

internal struct TorxShape: Shape2D {
    let size: TorxSize

    var body: any Geometry2D {
        let outerDiameter = size.outerDiameter

        Circle(diameter: 0.72 * outerDiameter)
            .adding {
                Circle(radius: 0.1 * outerDiameter)
                    .translated(x: 0.4 * outerDiameter)
                    .repeated(count: 6)
            }
            .rounded(insideRadius: 0.175 * outerDiameter)
    }
}

/// A Torx (six-pointed star) drive socket.
public struct TorxBoltHeadSocket: BoltHeadSocket {
    /// The Torx size designation.
    public let size: TorxSize
    /// Depth of the socket.
    public let depth: Double

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance

        let outerDiameter = size.outerDiameter + tolerance
        let cone = Cylinder(bottomDiameter: outerDiameter, topDiameter: 0, apexAngle: 90°)

        TorxShape(size: size)
            .offset(amount: tolerance / 2, style: .round)
            .extruded(height: depth + cone.height)
            .intersecting {
                Stack(.z, alignment: .center) {
                    Cylinder(diameter: outerDiameter, height: depth)
                    cone
                }
            }
    }
}

public extension BoltHeadSocket where Self == TorxBoltHeadSocket {
    /// A Torx (six-pointed star) drive socket.
    ///
    /// - Parameters:
    ///   - size: The Torx size designation.
    ///   - depth: Depth of the socket.
    static func torx(size: TorxSize, depth: Double) -> Self {
        TorxBoltHeadSocket(size: size, depth: depth)
    }
}
