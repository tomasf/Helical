import Foundation
import SwiftSCAD

public struct PhillipsBoltHeadSocket: BoltHeadSocket {
    private let fullWidth: Double
    private let crossDistanceBetweenCorners: Double // b
    private let cornerWidth: Double // e
    private let bottomWidth: Double // g
    private let slotWidth: Double // f
    private let filletRadius: Double // r
    private let cornerAcrossAngle: Angle // α
    private let cornerSlant: Angle // β

    private let topAngle = 26.5°
    private let bottomAngle = 28°

    public enum Size {
        case PH0
        case PH1
        case PH2
        case PH3
        case PH4
    }

    public init(size: Size, width: Double) {
        fullWidth = width

        switch size {
        case .PH0:
            crossDistanceBetweenCorners = 0.61
            cornerWidth = 0.3
            bottomWidth = 0.81
            slotWidth = 0.35
            filletRadius = 0.3
            cornerAcrossAngle = 135° //???
            cornerSlant = 7°

        case .PH1:
            crossDistanceBetweenCorners = 0.97
            cornerWidth = 0.45
            bottomWidth = 1.27
            slotWidth = 0.55
            filletRadius = 0.5
            cornerAcrossAngle = 138°
            cornerSlant = 7°

        case .PH2:
            crossDistanceBetweenCorners = 1.47
            cornerWidth = 0.82
            bottomWidth = 2.29
            slotWidth = 0.7
            filletRadius = 0.6
            cornerAcrossAngle = 140°
            cornerSlant = 5.75°

        case .PH3:
            crossDistanceBetweenCorners = 2.41
            cornerWidth = 2.0
            bottomWidth = 3.81
            slotWidth = 0.85
            filletRadius = 0.8
            cornerAcrossAngle = 146°
            cornerSlant = 5.75°

        case .PH4:
            crossDistanceBetweenCorners = 3.48
            cornerWidth = 2.4
            bottomWidth = 5.08
            slotWidth = 1.25
            filletRadius = 1
            cornerAcrossAngle = 153°
            cornerSlant = 7°
        }
    }

    public var depth: Double {
        let bottomDepth = bottomWidth / 2.0 * tan(bottomAngle)
        let topDepth = (fullWidth / 2 - bottomWidth / 2) / tan(topAngle)
        return topDepth + bottomDepth
    }

    public var body: any Geometry3D {
        readTolerance { tolerance in
            let crossDistanceBetweenCorners = self.crossDistanceBetweenCorners + tolerance
            let bottomWidth = self.bottomWidth + tolerance
            let slotWidth = self.slotWidth + tolerance
            let fullWidth = self.fullWidth + tolerance

            let topAngle = 26.5°
            let bottomAngle = 28°

            let bottomDepth = bottomWidth / 2.0 * tan(bottomAngle) // t1, ref.
            let topDepth = (fullWidth / 2 - bottomWidth / 2) / tan(topAngle)
            let depth = topDepth + bottomDepth

            let cornerFacetLength = cornerWidth / (2 * sin(cornerAcrossAngle / 2))
            let cornerAngleFromX = -(cornerAcrossAngle - 90°) / 2
            let cornerDistanceFromBottom = crossDistanceBetweenCorners / bottomWidth * bottomDepth

            let mask = Box([fullWidth / 2 + filletRadius, slotWidth, depth + 0.001])
                .aligned(at: .centerY)
                .adding {
                    let blockDepth = slotWidth
                    Box([0.01, blockDepth, depth + 2])
                        .translated(x: cornerFacetLength, y: -blockDepth, z: -1)
                        .rotated(z: cornerAngleFromX - 45°)
                        .rotated(y: cornerSlant)
                        .translated(x: crossDistanceBetweenCorners / 2, z: cornerDistanceFromBottom)
                        .rotated(z: 45°)
                        .symmetry(over: .y)

                        .adding {
                            Circle(diameter: fullWidth)
                                .intersection {
                                    Rectangle([fullWidth / 2, slotWidth])
                                        .aligned(at: .centerY)
                                }
                                .extruded(height: depth + 1)
                        }
                        .intersection {
                            Cylinder(diameter: fullWidth, height: depth + 0.001)
                        }
                        .convexHull()
                }
                .adding {
                    let blockDepth = slotWidth
                    Box([cornerFacetLength + 0.3, blockDepth, depth + 2])
                        .translated(x: -0.3, y: -blockDepth, z: -1)
                        .rotated(z: cornerAngleFromX - 45°)
                        .rotated(y: cornerSlant)
                        .translated(x: crossDistanceBetweenCorners / 2, z: cornerDistanceFromBottom)
                        .rotated(z: 45°)
                        .symmetry(over: .y)

                    Box([cornerWidth, 0.02, 0.02])
                        .aligned(at: .center)
                        .rotated(z: 45°)
                        .translated(z: 3)
                        .background()
                        .disabled()
                }
                .repeated(around: .z, count: 4)
                .translated(z: -depth)

            Union {
                Cylinder(bottomDiameter: bottomWidth, topDiameter: fullWidth, height: topDepth + 0.001)
                    .translated(z: -topDepth)

                Cylinder(bottomDiameter: 0, topDiameter: bottomWidth, height: bottomDepth + 0.001)
                    .translated(z: -depth)

                EdgeProfile
                    .fillet(radius: filletRadius)
                    .shape(angle: 90° + topAngle)
                    .flipped(along: .y)
                    .translated(x: fullWidth / 2 - 0.002)
                    .extruded()
                    .translated(z: 0.001)
            }
            .intersection(mask)
        }
        .flipped(along: .z)
    }
}
