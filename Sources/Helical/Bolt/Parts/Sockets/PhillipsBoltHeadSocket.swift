import Cadova

/// A Phillips cross drive socket.
///
/// Models the cruciform recess geometry of a Phillips-type screw drive,
/// including the tapered conical profile and corner wing features.
public struct PhillipsBoltHeadSocket: BoltHeadSocket {
    let size: PhillipsSize
    let width: Double

    /// Creates a Phillips cross drive socket.
    ///
    /// - Parameters:
    ///   - size: The Phillips driver size.
    ///   - width: The full width of the socket opening at the head surface.
    init(size: PhillipsSize, width: Double) {
        self.size = size
        self.width = width
    }

    /// The depth of the socket recess, derived from the Phillips size and width.
    public var depth: Double {
        PhillipsMetrics(size: self.size, width: width).depth
    }

    public var body: any Geometry3D {
        @Environment(\.tolerance) var tolerance

        let metrics = PhillipsMetrics(size: self.size, width: width)
        let crossDistanceBetweenCorners = metrics.crossDistanceBetweenCorners + tolerance
        let bottomWidth = metrics.bottomWidth + tolerance
        let slotWidth = metrics.slotWidth + tolerance
        let fullWidth = metrics.fullWidth + tolerance

        let bottomDepth = bottomWidth / 2.0 * tan(metrics.bottomAngle) // t1, ref.
        let topDepth = (fullWidth / 2 - bottomWidth / 2) / tan(metrics.topAngle)
        let depth = topDepth + bottomDepth

        let cornerFacetLength = metrics.cornerWidth / (2 * sin(metrics.cornerAcrossAngle / 2))
        let cornerAngleFromX = -(metrics.cornerAcrossAngle - 90°) / 2
        let cornerDistanceFromBottom = crossDistanceBetweenCorners / bottomWidth * bottomDepth

        let mask = Box([fullWidth / 2 + metrics.filletRadius, slotWidth, depth + 0.001])
            .aligned(at: .centerY)
            .adding {
                let blockDepth = slotWidth
                Box([0.01, blockDepth, depth + 2])
                    .translated(x: cornerFacetLength, y: -blockDepth, z: -1)
                    .rotated(z: cornerAngleFromX - 45°)
                    .rotated(y: metrics.cornerSlant)
                    .translated(x: crossDistanceBetweenCorners / 2, z: cornerDistanceFromBottom)
                    .rotated(z: 45°)
                    .symmetry(over: .y)
                    .adding {
                        Circle(diameter: fullWidth)
                            .intersecting {
                                Rectangle([fullWidth / 2, slotWidth])
                                    .aligned(at: .centerY)
                            }
                            .extruded(height: depth + 1)
                    }
                    .intersecting {
                        Cylinder(diameter: fullWidth, height: depth + 0.001)
                    }
                    .convexHull()
            }
            .adding {
                let blockDepth = slotWidth
                Box([cornerFacetLength + 0.3, blockDepth, depth + 2])
                    .translated(x: -0.3, y: -blockDepth, z: -1)
                    .rotated(z: cornerAngleFromX - 45°)
                    .rotated(y: metrics.cornerSlant)
                    .translated(x: crossDistanceBetweenCorners / 2, z: cornerDistanceFromBottom)
                    .rotated(z: 45°)
                    .symmetry(over: .y)
            }
            .repeated(around: .z, count: 4)
            .translated(z: -depth)

        Union {
            Cylinder(bottomDiameter: bottomWidth, topDiameter: fullWidth, height: topDepth + 0.001)
                .translated(z: -topDepth)

            Cylinder(bottomDiameter: 0, topDiameter: bottomWidth, height: bottomDepth + 0.001)
                .translated(z: -depth)
        }
        .intersecting(mask)
        .flipped(along: .z)
    }
}

public extension BoltHeadSocket where Self == PhillipsBoltHeadSocket {
    /// A Phillips cross drive socket.
    ///
    /// - Parameters:
    ///   - size: The Phillips driver size.
    ///   - width: The full width of the socket opening.
    static func phillips(size: PhillipsSize, width: Double) -> Self {
        PhillipsBoltHeadSocket(size: size, width: width)
    }
}
