import Foundation
import SwiftSCAD

extension StandardNut {
    /// Standard metric square nut, DIN 557
    static func squareNut(_ size: ScrewThread.ISOMetricSize) -> PolygonalNut {
        let width: Double // s, width across flats
        let thickness: Double // m

        (width, thickness) = switch size {
        case .m5:  (8,  4)
        case .m6:  (10, 5)
        case .m8:  (13, 6.5)
        case .m10: (16, 8)
        case .m12: (18, 10)
        case .m16: (24, 13)
        default: (-1, -1)
        }

        return squareNut(.isoMetric(size), s: width, m: thickness, chamferAngle: 30°)
    }

    /// Standard thin metric square nut, DIN 562
    static func thinSquareNut(_ size: ScrewThread.ISOMetricSize) -> PolygonalNut {
        let width: Double // s, width across flats
        let thickness: Double // m

        (width, thickness) = switch size {
        case .m1p6: (3.2, 1)
        case .m2:   (4,   1.2)
        case .m2p5: (5,   1.6)
        case .m3:   (5.5, 1.8)
        case .m3p5: (6,   2)
        case .m4:   (7,   2.2)
        case .m5:   (8,   2.7)
        case .m6:   (10,  3.2)
        case .m8:   (13,  4)
        case .m10:  (17,  5)
        default: (-1, -1)
        }

        return squareNut(.isoMetric(size), s: width, m: thickness, chamferAngle: 0°)
    }

    /// Custom configuration
    static func squareNut(_ thread: ScrewThread, s width: Double, m thickness: Double, chamferAngle: Angle) -> PolygonalNut {
        let outerRadius = RegularPolygon(sideCount: 4, apothem: width / 2).circumradius
        let chamferWidth = outerRadius - width / 2
        let chamfer = EdgeProfile.chamfer(width: chamferWidth, angle: chamferAngle)
        return .init(thread: thread, sideCount: 4, thickness: thickness, widthAcrossFlats: width, topCorners: chamfer, bottomCorners: .sharp, innerChamferAngle: 120°)
    }
}
