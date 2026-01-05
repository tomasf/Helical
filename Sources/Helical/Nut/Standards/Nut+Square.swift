import Foundation
import Cadova

/// Square nuts (DIN 557/562).
///
/// Standard metric square nuts in regular (DIN 557) and thin (DIN 562) variants.
public extension Nut {
    /// The thickness series for square nuts.
    enum SquaredNutSeries {
        /// Regular thickness (DIN 557).
        case regular
        /// Thin (DIN 562).
        case thin
    }

    /// Returns standard dimensions for a square nut.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - series: The thickness series.
    /// - Returns: A tuple of width across flats and thickness.
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

    /// Creates a standard DIN 557/562 square nut.
    ///
    /// - Parameters:
    ///   - size: The ISO metric thread size.
    ///   - series: The thickness series. Defaults to regular.
    static func square(_ size: ScrewThread.ISOMetricSize, series: SquaredNutSeries = .regular) -> Nut {
        let (width, thickness) = standardDimensionsForSquaredNut(size, series: series)
        let chamferAngle = (series == .regular) ? 30° : nil
        return square(.isoMetric(size), s: width, m: thickness, chamferAngle: chamferAngle)
    }

    /// Creates a square nut with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - width: Width across the flats.
    ///   - thickness: Height of the nut.
    ///   - chamferAngle: Optional angle for corner chamfers.
    static func square(_ thread: ScrewThread, s width: Double, m thickness: Double, chamferAngle: Angle? = nil) -> Nut {
        let outerRadius = RegularPolygon(sideCount: 4, apothem: width / 2).circumradius
        let chamferWidth = outerRadius - width / 2
        let shape = PolygonalNutBody(
            sideCount: 4,
            thickness: thickness,
            widthAcrossFlats: width,
            chamferAngle: chamferAngle,
            topChamferDepth: chamferWidth
        )
        return .init(thread: thread, shape: shape, innerChamferAngle: 120°)
    }
}
