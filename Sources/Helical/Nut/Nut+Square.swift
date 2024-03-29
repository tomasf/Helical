import Foundation
import SwiftSCAD

public extension StandardNut {
    enum SquaredNutSeries {
        case regular
        case thin
    }

    static func standardDimensionsForSquaredNut(_ size: ScrewThread.ISOMetricSize, series: SquaredNutSeries = .regular) -> (width: Double, thickness: Double) {

        let width: Double // s, width across flats
        let regularThickness: Double
        let thinThickness: Double

        (width, regularThickness, thinThickness) = switch size {
        case .m1p6: (3.2, -1,  1)
        case .m2:   (4,   -1,  1.2)
        case .m2p5: (5,   -1,  1.6)
        case .m3:   (5.5, -1,  1.8)
        case .m3p5: (6,   -1,  2)
        case .m4:   (7,   -1,  2.2)
        case .m5:   (8,   4,   2.7)
        case .m6:   (10,  5,   3.2)
        case .m8:   (13,  6.5, 4)
        case .m10:  (17,  8,   5)
        case .m12:  (18,  10,  -1)
        case .m16:  (24,  13,  -1)
        default: (-1, -1, -1)
        }

        let thickness = (series == .regular) ? regularThickness : thinThickness
        assert(width > 0 && thickness > 0, "\(size) isn't a valid size for this kind of nut")
        return (width, thickness)
    }

    /// Standard metric square nut, DIN 557
    /// Standard thin metric square nut, DIN 562
    static func squareNut(_ size: ScrewThread.ISOMetricSize, series: SquaredNutSeries = .regular) -> PolygonalNut {

        let (width, thickness) = standardDimensionsForSquaredNut(size, series: series)
        let chamferAngle = (series == .regular) ? 30° : 0°
        return squareNut(.isoMetric(size), s: width, m: thickness, chamferAngle: chamferAngle)
    }

    /// Custom configuration
    static func squareNut(_ thread: ScrewThread, s width: Double, m thickness: Double, chamferAngle: Angle) -> PolygonalNut {
        let outerRadius = RegularPolygon(sideCount: 4, apothem: width / 2).circumradius
        let chamferWidth = outerRadius - width / 2
        let chamfer = EdgeProfile.chamfer(width: chamferWidth, angle: chamferAngle)
        return .init(thread: thread, sideCount: 4, thickness: thickness, widthAcrossFlats: width, topCorners: chamfer, bottomCorners: .sharp, innerChamferAngle: 120°)
    }
}
