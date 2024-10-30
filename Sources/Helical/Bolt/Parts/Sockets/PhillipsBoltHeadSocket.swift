import Foundation
import SwiftSCAD

public struct PhillipsBoltHeadSocket: BoltHeadSocket {
    let size: PhillipsSize
    let fullWidth: Double

    init(size: PhillipsSize, width: Double) {
        self.size = size
        self.fullWidth = width
    }

    public var depth: Double {
        PhillipsMetrics(size: self.size, width: fullWidth).depth
    }

    public var body: any Geometry3D {
        readTolerance { tolerance in
            let metrics = PhillipsMetrics(size: self.size, width: fullWidth)
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

                    Box([metrics.cornerWidth, 0.02, 0.02])
                        .aligned(at: .center)
                        .rotated(z: 45°)
                        .translated(z: 3)
                        .background()
                        .disabled()
                }
                .repeated(around: .z, count: 4)
                .translated(z: -depth)

            union {
                Cylinder(bottomDiameter: bottomWidth, topDiameter: fullWidth, height: topDepth + 0.001)
                    .translated(z: -topDepth)

                Cylinder(bottomDiameter: 0, topDiameter: bottomWidth, height: bottomDepth + 0.001)
                    .translated(z: -depth)

                EdgeProfile
                    .fillet(radius: metrics.filletRadius)
                    .shape(angle: 90° + metrics.topAngle)
                    .flipped(along: .y)
                    .translated(x: fullWidth / 2 - 0.002)
                    .extruded()
                    .translated(z: 0.001)
            }
            .intersecting(mask)
        }
        .flipped(along: .z)
    }
}
